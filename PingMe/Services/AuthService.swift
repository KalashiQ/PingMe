import Foundation

enum AuthError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case serverError(String)
}

class AuthService {
    #if DEBUG
    private let baseURL = "http://localhost:8000"
    #else
    private let baseURL = "https://your-production-url.com"
    #endif
    
    func register(email: String, password: String, name: String) async throws -> APIResponse<RegisterResponseData> {
        let request = RegisterRequest(email: email, password: password, name: name)
        return try await performRequest(endpoint: "/auth/register", body: request)
    }
    
    func verifyRegistration(email: String, password: String, token: String) async throws -> APIResponse<VerifyResponseData> {
        let request = VerifyRegistrationRequest(email: email, password: password, token: token)
        return try await performRequest(endpoint: "/auth/verify-registration", body: request)
    }
    
    private func performRequest<T: Codable, R: Codable>(endpoint: String, body: T) async throws -> APIResponse<R> {
        guard let url = URL(string: baseURL + endpoint) else {
            throw AuthError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        if httpResponse.statusCode == 422 {
            let errorResponse = try JSONDecoder().decode(ValidationErrorResponse.self, from: data)
            throw AuthError.serverError(errorResponse.detail.first?.msg ?? "Validation error")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode(APIResponse<R>.self, from: data)
        } catch {
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
