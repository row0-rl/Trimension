import Foundation

struct TagModel: Codable, Identifiable {
    var id: Int8
    var en: String?
    var zh_hans: String?
    var zh_hant: String?
    var fr: String?
    var es: String?
}

struct WallpaperModel: Codable, Identifiable {
    var id: Int8
    var upload_time: Date
    var name: String
    var description: String?
    var filename: String
    var preview_filename: String
    var user_id: UUID
}

struct WallpaperThumbnailModel: Codable, Identifiable {
    var id: Int8
    var name: String
    var description: String?
    var preview_filename: String
    var type: String
    var user: User
    
    struct User: Codable {
        var name: String
    }
}

struct WallpaperDetailModel: Codable, Identifiable {
    var id: Int8
    var upload_time: Date
    var name: String
    var description: String?
    var preview_filename: String
    var width: Int?
    var height: Int?
    var type: String
    var user: User
    
    struct User: Codable {
        var id: UUID
        var name: String
    }
}

struct User: Codable, Identifiable {
    var id: UUID
    var name: String
    var avatar: String
}
