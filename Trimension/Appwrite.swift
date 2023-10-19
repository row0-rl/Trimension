import Foundation
import Appwrite
import JSONCodable

class Appwrite {
    var client: Client
    var account: Account
    var databases: Databases
    var storage: Storage
    
    static let shared = Appwrite()
    
    private init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("652d954fcadd7f7f81b5")
            .setSelfSigned(true) // For self signed certificates, only use for development
        
        self.account = Account(client)
        self.databases = Databases(client)
        self.storage = Storage(client)
    }
    
    public func onRegister(
        _ email: String,
        _ password: String
    ) async throws -> AppwriteModels.User<[String: AnyCodable]> {
        try await account.create(
            userId: ID.unique(),
            email: email,
            password: password
        )
    }
    
    public func onLogin(
        _ email: String,
        _ password: String
    ) async throws -> Session {
        try await account.createEmailSession(
            email: email,
            password: password
        )
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
}

