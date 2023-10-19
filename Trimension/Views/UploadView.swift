import SwiftUI
import AppKit
import AVKit
import Supabase
import SupabaseStorage
import QuickLookThumbnailing

struct UploadView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedFileURL: URL?
    @State private var isShowingOpenPanel = false
    
    var body: some View {
        Group {
            HStack {
                Button {
                    isShowingOpenPanel = true
                } label: {
                    Text("Select file")
                }
                .fileImporter(
                    isPresented: $isShowingOpenPanel,
                    allowedContentTypes: [.image, .movie],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        selectedFileURL = try result.get()[0]
                    } catch {
                        print("File selection error: \(error)")
                    }
                }
                if let selectedFileURL = selectedFileURL {
                    Text(selectedFileURL.lastPathComponent)
                }
                VStack {
                    TextField("Name", text: $name, prompt: Text("Name"))
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black)
                        )
                        .frame(width: 270, height: 40)
                    
                    TextField("Descritpion", text: $description, prompt: Text("Description"))
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black)
                        )
                        .frame(width: 270, height: 40)
                    Button {
                        upload()
                    } label: {
                        Text("Submit")
                    }
                }
            }
        }
        .onSubmit {
            upload()
        }
        .frame(maxWidth: .infinity)
    }
    
    func upload() {
        guard let selectedFileURL else {
            return
        }
        
        let gotAccess = selectedFileURL.startAccessingSecurityScopedResource()
        if !gotAccess { return }
        
        let fileType = (selectedFileURL.lastPathComponent as NSString).pathExtension
        
        Task {
            
            var wallpaper = await WallpaperModel(
                name: name,
                description: description,
                type: fileType,
                user_id: SupabaseProvider.shared.loggedInUserId()!
            )
            let size = await getResolution(url: selectedFileURL, type: wallpaper.getType())
            wallpaper.width = size[0]
            wallpaper.height = size[1]

            do {
                let response: [WallpaperModel] = try await SupabaseProvider.shared.client.database.from("wallpaper")
                    .insert(values: wallpaper, returning: .representation).select(columns: "id, type").execute().value
                wallpaper = response[0]
                
                guard let filename = wallpaper.getFileName() else { return }
                let data = try Data(contentsOf: selectedFileURL)
                print(data.count)
                guard let image = NSImage(data: data) else { return }
                
//                let file = File(name: name, data: data, fileName: filename, contentType: fileType)
//                try await SupabaseProvider.shared.storage.from(id: "wallpaper")
//                    .upload(path: filename, file: file, fileOptions: FileOptions(cacheControl: "3600"))
                var previewFile = image.resize(width: image.size.width * (image.size.height/1080), height: 1080)
                guard var previewData = previewFile.compressUnderMegaBytes(megabytes: 1) else { return }
                
                let previewGenerator = QLThumbnailGenerator()
                let size = CGSize(width: image.size.width * (image.size.height / 1080), height: 1080)
                let request = QLThumbnailGenerator.Request(fileAt: selectedFileURL, size: size, scale: 1, representationTypes: .thumbnail)
                previewGenerator.generateBestRepresentation(for: request) { (thumbnail, error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else if let thumb = thumbnail {
                        
                        print( thumb.nsImage) // image available
                    }

                }
                

                
                print(previewData.count)
//                let previewFile = File(name: name, data: previewData, fileName: name+".jpg", contentType: "jpg")
//                try await SupabaseProvider.shared.storage.from(id: "wallpaper-preview")
//                    .upload(path: filename, file: previewFile, fileOptions: FileOptions(cacheControl: "3600"))
                
                selectedFileURL.stopAccessingSecurityScopedResource()
            } catch {
                print(error)
            }
        }
    }
    
    func getResolution(url: URL, type: UTType?) async -> [Int] {
        guard let type else { return [0, 0] }
        switch type {
        case .image:
            if let image = NSImage(contentsOf: url) {
                return [Int(image.size.width), Int(image.size.height)]
            }
            return [0, 0]
        case .movie:
            do {
                guard let track = try await AVURLAsset(url: url).loadTracks(withMediaType: AVMediaType.video).first else { return [0, 0] }
                let size = try await track.load(.naturalSize).applying(track.load(.preferredTransform))
                return [Int(size.width), Int(size.height)]
            } catch {
                print(error)
                return [0, 0]
            }
        default:
            return [0, 0]
        }
    }
}

extension NSImage {
    func compressUnderMegaBytes(megabytes: CGFloat) -> Data? {
        var compressionRatio = 0.5
        guard let tiff = self.tiffRepresentation, let imageRep = NSBitmapImageRep(data: tiff) else { return nil }
        var compressedData = imageRep.representation(using: .jpeg, properties: [.compressionFactor : compressionRatio])!
        var lastCount = compressedData.count
        while CGFloat(compressedData.count) > megabytes * 1024 * 1024 {
            print(compressedData.count)
            compressionRatio = compressionRatio * 0.7
            compressedData = imageRep.representation(using: .jpeg, properties:  [.compressionFactor : compressionRatio])!
            if compressedData.count == lastCount {
                break
            }
            lastCount = compressedData.count
        }
        return compressedData
    }
    
    func resize(width: CGFloat, height: CGFloat) -> NSImage {
        var destSize = NSMakeSize(width, height)
        var newImage = NSImage(size: destSize)
        newImage.lockFocus()
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, self.size.width, self.size.height), operation: .sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        
        return newImage
    }
}
