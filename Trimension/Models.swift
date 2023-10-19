import Foundation
import AVKit

struct TagModel: Codable, Identifiable {
    var id: Int8
    var en: String?
    var zh_hans: String?
    var zh_hant: String?
    var fr: String?
    var es: String?
}

struct WallpaperModel: Codable, Identifiable {
    var id: Int8?
    var upload_time: Date?
    var name: String?
    var description: String?
    var type: String?
    var user_id: UUID?
    var width: Int?
    var height: Int?
    var user: User?
    
    func getFileName() -> String? {
        if let id, let type {
            return String(id) + "." + type
        }
        return nil
    }
    
    func getType() -> UTType? {
        guard let type else {
            return nil
        }
        if let type = UTType(filenameExtension: type) {
            if type.conforms(to: .image) {
                return .image
            }
            if type.conforms(to: .movie) {
                return .movie
            }
        }
        return nil
    }
}

struct WallpaperThumbnailModel: Codable, Identifiable {
    var id: Int8
    var name: String
    var description: String?
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
    var type: String
    var width: Int
    var height: Int
    var user: User
    
    struct User: Codable {
        var id: UUID
        var name: String
    }
}

struct WallpaperUploadModel: Codable {
    var name: String
    var description: String?
    var type: String
    var user_id: UUID
    var width: Int
    var height: Int
}

struct WallpaperIdModel: Codable {
    var id: Int8
}

struct User: Codable, Identifiable {
    var id: UUID?
    var name: String?
    var avatar: String?
}
