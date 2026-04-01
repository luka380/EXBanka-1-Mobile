import Foundation
import Security

enum KeychainService {
    private static let accessTokenKey = "banka.access_token"
    private static let refreshTokenKey = "banka.refresh_token"

    static func saveAccessToken(_ token: String) {
        save(key: accessTokenKey, value: token)
    }

    static func loadAccessToken() -> String? {
        load(key: accessTokenKey)
    }

    static func saveRefreshToken(_ token: String) {
        save(key: refreshTokenKey, value: token)
    }

    static func loadRefreshToken() -> String? {
        load(key: refreshTokenKey)
    }

    static func deleteAll() {
        delete(key: accessTokenKey)
        delete(key: refreshTokenKey)
    }

    private static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    private static func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
        return value
    }

    private static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
