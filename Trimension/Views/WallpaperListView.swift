import SwiftUI
import SupabaseStorage
import AVKit


let query_wallpapers = SupabaseProvider.shared.supabaseClient.database.from("wallpaper")
        .select(columns: """
                         id,
                         name,
                         description,
                         preview_filename,
                         type,
                         user: user_id(name)
                         """)


struct WallpaperListView: View {
    @State private var wallpapers = [WallpaperThumbnailModel]()
    
    @EnvironmentObject var searchBarText: SearchBarText
    
    let columns = [
            GridItem(.flexible(minimum: 380, maximum: 400)),
            GridItem(.flexible(minimum: 380, maximum: 400)),
    ]
    
    func getWallpapers() async {
        do {
            wallpapers = try await query_wallpapers.execute().value
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationStack {
            SearchBar(text: _searchBarText)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(wallpapers) { wallpaper in
                        NavigationLink {
                            WallpaperDetailView(preview_filename: wallpaper.preview_filename, title: wallpaper.name, description: wallpaper.description, publisher: wallpaper.user.name)
                                .navigationBarBackButtonHidden()
                        } label: {
                            switch wallpaper.type {
                            case "bitmap":
                                CardView(thumbnail: wallpaper.preview_filename, title: wallpaper.name, publisher: wallpaper.user.name)
                            case "video":
                                VideoCardView(thumbnail: wallpaper.preview_filename, title: wallpaper.name, publisher: wallpaper.user.name)
                            default:
                                EmptyView()
                            }
                            
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .task {
            await getWallpapers()
        }
    }
}

struct CardView: View {
    @State private var isHovered = false
    @State private var image: Image?
    var thumbnail: String
    var title: String
    var publisher: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: isHovered ? 15 : 5)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .redacted(reason: .placeholder)
            }
            Text(title)
                .font(.title3)
                .bold()
                .padding(.leading, 5)
            Text("by " + publisher)
                .padding(.leading, 5)
            Spacer()
        }
        .frame(width: 350, height: 270)
        .whenHovered { hovering in
            isHovered = hovering
        }
        .hoverCursor()
        .scaleEffect(isHovered ? 1.01 : 1)
        .animation(.easeInOut(duration: 0.5), value: isHovered)
        .task {
            do {
                let data = try await SupabaseProvider.shared.supabaseStorageClient.from(id: "wallpaper").download(path: thumbnail)
                if let nsImage = NSImage(data: data) {
                    image = Image(nsImage: nsImage)
                } else {
                    print("Corrupted thumbnail image")
                }
            }
            catch {
                print("error: \(error)")
            }
        }
    }
}

struct VideoCardView: View {
    @State private var isHovered = false
    @State private var playerItem: AVPlayerItem?
    var thumbnail: String
    var title: String
    var publisher: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if let playerItem = playerItem {
                VideoCardThumbnail(playerItem: playerItem)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1.6, contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .redacted(reason: .placeholder)
            }
            Text(title)
                .font(.title3)
                .bold()
                .padding(.leading, 5)
            Text("by " + publisher)
                .padding(.leading, 5)
            Spacer()
        }
        .frame(width: 350, height: 270)
        .whenHovered { hovering in
            isHovered = hovering
        }
        .hoverCursor()
        .scaleEffect(isHovered ? 1.01 : 1)
        .animation(.easeInOut(duration: 0.5), value: isHovered)
        .task {
            do {
                let url = try SupabaseProvider.shared.supabaseStorageClient.from(id: "wallpaper").getPublicURL(path: thumbnail)
                self.playerItem = AVPlayerItem(url: url)
            }
            catch {
                print(error)
            }
        }

    }
}

struct VideoCardThumbnail: NSViewRepresentable {
    let playerItem: AVPlayerItem
    
    func makeNSView(context: Context) -> NSView {
        return loopingVideoView(frame: .infinite, playerItem: playerItem)
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
    }
}

class loopingVideoView: NSView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(frame: CGRect, playerItem: AVPlayerItem) {
        super.init(frame: .zero)
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.isMuted = true
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer = playerLayer
        
        player.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resetCursorRects() {
        addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
    }
}
