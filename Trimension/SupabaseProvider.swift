import Foundation
import Supabase
import SupabaseStorage
import GoTrue
@preconcurrency import KeychainAccess

class SupabaseProvider {
    
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJocmlzYmVsZHR0ZHJsZnB5emxwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTMxNzEyMTMsImV4cCI6MjAwODc0NzIxM30.t9egc7ZOuBMvAuJIWiU8CeowPLa4XdWY9IWULGyYWug"
    private let supabaseUrl = URL(string: "https://bhrisbeldttdrlfpyzlp.supabase.co")!
    private let options = SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(storage: KeychainLocalStorage(service: "trimension", accessGroup: "trimension")))
    
    private init() {}
    
    static let shared = SupabaseProvider()
    
    lazy var supabaseClient: SupabaseClient = {
        return SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: apiKey, options: options)
    }()
    
    lazy var supabaseStorageClient: SupabaseStorageClient = {
        return supabaseClient.storage
    }()
    
    func isAuthenticated() async -> Bool {
        let session = try? await SupabaseProvider.shared.supabaseClient.auth.session
        return session != nil
    }
    
    func loggedInUserId() async -> UUID? {
        return try? await SupabaseProvider.shared.supabaseClient.auth.session.user.id
    }
    
//    private var keysPlist: NSDictionary {
//        if
//            let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
//            let dictionary = NSDictionary(contentsOfFile: path) {
//            return dictionary
//        }
//        fatalError("You must have a Keys.plist file in your application codebase.")
//    }
//    
//    private var apiKey: String {
//        guard let apiKey = keysPlist[apiDictionaryKey] as? String else {
//            fatalError("Your Keys.plist must have a key of: \(apiDictionaryKey) and a corresponding value of type String.")
//        }
//        return apiKey
//    }
//    
//    var supabaseUrl: URL {
//        guard let url = keysPlist[supabaseUrlKey] as? String else {
//            fatalError("Your Keys.plist must have a key of: \(supabaseUrlKey) and a corresponding value of type String.")
//        }
//        return URL(string: url)!
//    }
    
    // Storage
    
//    func storageClient(bucketName: String = "wallpaper") async -> StorageFileApi? {
//        guard let jwt = try? await supabaseClient.auth.session.accessToken else { return nil}
//        return SupabaseStorageClient(
//            url: "\(supabaseUrl)/storage/v1",
//            headers: [
//                "Authorization": "Bearer \(jwt)",
//                "apikey": apiKey,
//            ]
//        ).from(id: bucketName)
//    }
}

struct KeychainLocalStorage: GoTrueLocalStorage {
  private let keychain: Keychain

  init(service: String, accessGroup: String?) {
    if let accessGroup {
      keychain = Keychain(service: service, accessGroup: accessGroup)
    } else {
      keychain = Keychain(service: service)
    }
  }

  func store(key: String, value: Data) throws {
    try keychain.set(value, key: key)
  }

  func retrieve(key: String) throws -> Data? {
    try keychain.getData(key)
  }

  func remove(key: String) throws {
    try keychain.remove(key)
  }
}
