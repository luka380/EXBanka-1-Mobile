import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(statusCode: Int, message: String)
    case decodingError(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let e): return e.localizedDescription
        case .httpError(_, let msg): return msg
        case .decodingError(let e): return "Decode error: \(e.localizedDescription)"
        case .unauthorized: return "Session expired. Please log in again."
        }
    }
}

actor APIClient {
    static let shared = APIClient()
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private init() {}

    func request<T: Decodable>(
        endpoint: Endpoint,
        body: Encodable? = nil,
        accessToken: String? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint.urlString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError(URLError(.badServerResponse))
        }

        if http.statusCode == 401 { throw APIError.unauthorized }

        guard (200..<300).contains(http.statusCode) else {
            let message = (try? JSONDecoder().decode(APIErrorResponse.self, from: data))?.error ?? "HTTP \(http.statusCode)"
            throw APIError.httpError(statusCode: http.statusCode, message: message)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

private struct APIErrorResponse: Decodable {
    let error: String
}
