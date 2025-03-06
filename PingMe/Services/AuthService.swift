import Foundation

enum AuthError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case serverError(String)
}

class AuthService {
    private let baseURL = "http://localhost:8000"

    func register(email: String, password: String, name: String) async throws -> APIResponse<
        RegisterResponseData
    > {
        let request = RegisterRequest(email: email, password: password, name: name)
        return try await performRequest(endpoint: "/api/v1/auth/register", body: request)
    }

    func verifyRegistration(email: String, password: String, token: String) async throws
        -> APIResponse<VerifyResponseData> {
        let request = VerifyRegistrationRequest(email: email, password: password, token: token)
        return try await performRequest(endpoint: "/api/v1/auth/verify-registration", body: request)
    }

    func login(email: String, password: String) async throws -> APIResponse<RegisterResponseData> {
        let request = LoginRequest(email: email, password: password)
        return try await performRequest(endpoint: "/api/v1/auth/login", body: request)
    }

    func verifyLogin(email: String, password: String, token: String) async throws -> APIResponse<
        VerifyResponseData
    > {
        let request = VerifyLoginRequest(email: email, password: password, token: token)
        return try await performRequest(endpoint: "/api/v1/auth/verify-login", body: request)
    }

    private func performRequest<T: Codable, R: Codable>(endpoint: String, body: T) async throws
        -> APIResponse<R> {
        guard let url = URL(string: baseURL + endpoint) else {
            print("Invalid URL: \(baseURL + endpoint)")
            throw AuthError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        // Отладочная информация запроса
        print("=== Request Debug Info ===")
        print("URL: \(url)")
        print("Method: \(request.httpMethod ?? "Unknown")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request Body: \(jsonString)")
        }
        print("=======================")

        let (data, response) = try await URLSession.shared.data(for: request)

        // Отладочная информация ответа
        print("=== Response Debug Info ===")
        print("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response Body: \(jsonString)")
        }
        print("========================")

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        if httpResponse.statusCode == 422 {
            let errorResponse = try JSONDecoder().decode(ValidationErrorResponse.self, from: data)
            throw AuthError.serverError(errorResponse.detail.first?.msg ?? "Validation error")
        }

        let decoder = JSONDecoder()

        // Создаем форматтер даты
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Устанавливаем кастомную стратегию декодирования даты
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            // Пробуем разные форматы даты
            let formats = [
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ",
                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                "yyyy-MM-dd'T'HH:mm:ss",
            ]

            for format in formats {
                dateFormatter.dateFormat = format
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }

        do {
            return try decoder.decode(APIResponse<R>.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            print(
                "Failed to decode data: \(String(data: data, encoding: .utf8) ?? "Unable to read data")"
            )
            throw AuthError.decodingError
        }
    }
}

struct ValidationErrorDetail: Codable {
    let loc: [String]
    let msg: String
    let type: String
}

struct ValidationErrorResponse: Codable {
    let detail: [ValidationErrorDetail]
}
