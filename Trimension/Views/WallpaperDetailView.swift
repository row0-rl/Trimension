import SwiftUI
import AppKit
import AVKit

struct WallpaperDetailView: View {
    @State private var backBtnHovered = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var searchBarText: SearchBarText
    let id: Int8
    @State var wallpaper: WallpaperModel = WallpaperModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image("back")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fontWeight(.bold)
                            .foregroundColor(backBtnHovered ? .white : Color(NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(.borderless)
                .whenHovered { hovering in
                    if hovering {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            backBtnHovered = true
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            backBtnHovered = false
                        }
                    }
                }
                .hoverCursor()
                .padding(.top)
                Spacer()
                SearchBar(text: _searchBarText)
                    .padding(.trailing)
            }
            if let type = wallpaper.getType() {
                switch type {
                case .image:
                    BitmapWallpaperDetailView(wallpaper: wallpaper)
                case .movie:
                    VideoWallpaperDetailView(wallpaper: wallpaper)
                default:
                    Text("Unknown error")
                }
            } else {
                Text("Loading...")
            }
            Spacer()
        }
        .task {
            do {
                let query = SupabaseProvider.shared.client.database.from("wallpaper")
                    .select(columns: """
                     *,
                     user: user_id(id, name)
                     """)
                    .match(query: ["id": Int(id)]).single()
                wallpaper = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }
}
    
struct BitmapWallpaperDetailView: View {
    @State private var isHovered = false
    @State private var preview: Image = Image(systemName: "photo")
    let wallpaper: WallpaperModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    preview
                        .resizable()
                        .aspectRatio(1.6, contentMode: .fit)
                        .cornerRadius(10)
                        .frame(minWidth: 496, minHeight: 310)
                    if let name = wallpaper.name {
                        Text(name)
                            .font(.title)
                            .padding([.bottom], 5)
                            .textSelection(.enabled)
                        Text(wallpaper.description ?? "")
                            .foregroundColor(.gray)
                            .textSelection(.enabled)
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Title")
                        .padding()
                    Text("Description")
                    Button(action:  {
                        guard let filename = wallpaper.getFileName() else { return }
                        Task {
                            let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                            let data = try await SupabaseProvider.shared.storage.from(id: "wallpaper").download(path: filename)
                            do {
                                try data.write(to: path)
                                WallpaperManager.shared.setStatic(url: path)
                                print("Successful!")
                            } catch {
                                print(error)
                            }
                        }
                    }) {
                        Text("Set as wallpaper")
                    }
                    .buttonStyle(.plain)
                    .background(BlurEffect(material: .menu))
                    .cornerRadius(10)
                    .frame(width: 100, height: 30)
                }
                .padding()
                .frame(minWidth: 300, maxWidth: .infinity)
                .frame(minHeight: 310)
                .background(BlurEffect(material: .popover))
                .cornerRadius(10)
                
            }
            .padding()
        }
        .task {
            // TODO preview
            guard let filename = wallpaper.getFileName() else { return }
            do {
                let data = try await SupabaseProvider.shared.storage.from(id: "wallpaper").download(path: filename)
                if let nsImage = NSImage(data: data) {
                    preview = Image(nsImage: nsImage)
                } else {
                    print("Corrupted preview image")
                }
            }
            catch {
                print(error)
            }
        }
    }
}

struct VideoWallpaperDetailView: View {
    @State private var isHovered = false
    @State private var playerItem: AVPlayerItem?
    let wallpaper: WallpaperModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if let playerItem = playerItem {
                        VideoCardThumbnail(playerItem: playerItem)
                            .cornerRadius(10)
                            .aspectRatio(1.6, contentMode: .fit)
                            .frame(minWidth: 496, minHeight: 310)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(1.6, contentMode: .fit)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .frame(minWidth: 496, minHeight: 310)
                            .redacted(reason: .placeholder)
                    }
                    if let name = wallpaper.name {
                        Text(name)
                            .font(.title)
                            .padding([.bottom], 5)
                            .textSelection(.enabled)
                        Text(wallpaper.description ?? "")
                            .foregroundColor(.gray)
                            .textSelection(.enabled)
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Title")
                        .padding()
                    Text("Description")
                    Button(action:  {
                        WallpaperManager.shared.stop()
                        guard let filename = wallpaper.getFileName() else { return }
                        let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                        Task {
                            let data = try await SupabaseProvider.shared.storage.from(id: "wallpaper").download(path: filename)
                            do {
                                try data.write(to: path)
                            } catch {
                                print(error)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            WallpaperManager.shared.setVideo(url: path)
                        }
                        
                    }) {
                        Text("Set as wallpaper")
                    }
                    .buttonStyle(.plain)
                    .background(BlurEffect(material: .menu))
                    .cornerRadius(10)
                    .frame(width: 100, height: 30)
                }
                .padding()
                .frame(minWidth: 300, maxWidth: .infinity)
                .frame(minHeight: 310)
                .background(BlurEffect(material: .popover))
                .cornerRadius(10)
                
            }
            .padding()
        }
        .task {
            // TODO preview
            guard let filename = wallpaper.getFileName() else { return }
            do {
                let url = try SupabaseProvider.shared.storage.from(id: "wallpaper").getPublicURL(path: filename)
                self.playerItem = AVPlayerItem(url: url)
            }
            catch {
                print(error)
            }
        }
    }
}
