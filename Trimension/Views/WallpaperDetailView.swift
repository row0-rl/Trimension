import SwiftUI
import AppKit

struct WallpaperDetailView: View {
    @State private var isHovered = false
    @State private var preview: Image = Image(systemName: "photo")
    var preview_filename: String
    var title: String
    var description: String?
    var publisher: String
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var searchBarText: SearchBarText
    
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
                            .foregroundColor(isHovered ? .white : Color(NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
                            .frame(width: 30, height: 30)
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(.borderless)
                .whenHovered { hovering in
                    if hovering {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isHovered = true
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isHovered = false
                        }
                    }
                }
                .hoverCursor()
                .padding(.top)
                Spacer()
                SearchBar(text: _searchBarText)
                    .padding(.trailing)
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    preview
                        .resizable()
                        .aspectRatio(1.6, contentMode: .fit)
                        .cornerRadius(10)
                        .frame(minWidth: 496, minHeight: 310)
                    Text(title)
                        .font(.title)
                        .padding([.bottom], 5)
                        .textSelection(.enabled)
                    Text(description ?? "")
                        .foregroundColor(.gray)
                        .textSelection(.enabled)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Title")
                        .padding()
                    Text("Description")
                    Button(action:  {
                        Task {
                            let path = FileManager.default.temporaryDirectory.appendingPathComponent(preview_filename)
                            let data = try await SupabaseProvider.shared.supabaseStorageClient.from(id: "wallpaper").download(path: preview_filename)
                            do {
                                try data.write(to: path)
                                try NSWorkspace.shared.setDesktopImageURL(path, for: NSScreen.main!, options: [:])
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
                Spacer()
            }
            .padding()
            .task {
                do {
                    let data = try await SupabaseProvider.shared.supabaseStorageClient.from(id: "wallpaper").download(path: preview_filename)
                    if let nsImage = NSImage(data: data) {
                        preview = Image(nsImage: nsImage)
                    } else {
                        print("Corrupted preview image")
                    }
                }
                catch {
                    print("error: \(error)")
                }
            }


        }
    }
}

//struct WallpaperDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        WallpaperDetailView(preview: "thumbnail2")
//    }
//}
