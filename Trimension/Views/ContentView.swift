import SwiftUI
import AppKit
import WebKit
import AVFoundation
import Supabase


enum Panel: String {
    case homepage = "Home"
    case wallpapers = "Wallpaper"
    case widgets = "Widget"
    case user = "User"
    case settings = "Settings"
}

struct ContentView: View {
    @State var selection: Panel = .homepage
    @State var currentWallpaperURL = URL(string: "")
    @State var widgets: [WidgetWindow] = []
    @State var userId: UUID?
    @State var isAuthenticated = false
    
    @StateObject var sharedSearchBarText = SearchBarText()
    
    var body: some View {
        HStack {
            VStack {
                TabButton(image: "home", panel: .homepage, selection: $selection)
                    .frame(width: 30, height: 30)
                    .padding()
                TabButton(image: "wallpaper", panel: .wallpapers, selection: $selection)
                    .frame(width: 30, height: 30)
                    .padding()
                TabButton(image: "widget", panel: .widgets, selection: $selection)
                    .frame(width: 30, height: 30)
                    .padding()
                Spacer()
                TabButton(image: "user", panel: .user, selection: $selection)
                    .frame(width: 30, height: 30)
                    .padding()
                TabButton(image: "settings", panel: .settings, selection: $selection)
                    .frame(width: 30, height: 30)
                    .padding()
            }
            .padding()
            .background(BlurEffect(material: .menu).ignoresSafeArea())
            Spacer()
            
            switch selection {
            case .homepage:
                WallpaperListView()
                    .environmentObject(sharedSearchBarText)
            case .wallpapers:
                WallpaperListView()
                    .environmentObject(sharedSearchBarText)
            case .widgets:
                EmptyView()
            case .user:
                if isAuthenticated {
                    if let userId = userId {
                        ProfileView(userId: userId)
                    }
                } else {
                    LoginView()
                }
            case .settings:
                EmptyView()
            }
        }
        .task {
            isAuthenticated = await SupabaseProvider.shared.isAuthenticated()
            userId = await SupabaseProvider.shared.loggedInUserId()
            for await event in SupabaseProvider.shared.supabaseClient.auth.authEventChange {
                if event == .signedIn {
                    isAuthenticated = true
                    userId = await SupabaseProvider.shared.loggedInUserId()
                }
                if event == .signedOut {
                    isAuthenticated = false
                    userId = nil
                }
            }
        }


        
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//                .padding()
//            Text("Welcome to Trimension!")
//                .bold()
//
//            // Test wallpaper
//            Button(action:  {
//                self.currentWallpaperURL = NSWorkspace.shared.desktopImageURL(for: NSScreen.main!)
//                let newWallpaperURL = URL(fileURLWithPath: "/Users/row0/Desktop/image.jpeg")
//                do {
//                    try NSWorkspace.shared.setDesktopImageURL(newWallpaperURL, for: NSScreen.main!, options: [:])
//                    print("Successful!")
//                } catch {
//                    print(error)
//                }
//            }) {
//                Text("Test")
//            }
//            .background(Color.orange)
//            .cornerRadius(8)
//
//            // Undo
//            Button(action: {
//                do {
//                    try NSWorkspace.shared.setDesktopImageURL(self.currentWallpaperURL!, for: NSScreen.main!, options: [:])
//                    print("Successful!")
//                } catch {
//                    print(error)
//                }
//            }) {
//                Text("Undo")
//            }
//            .background(Color.red)
//            .cornerRadius(8)
//
//            // Test dynamic wallpaper
//            Button(action: {
//                DynamicWallpaperView()
//            }) {
//                Text("Test Dynamic Wallpaper")
//            }
//
//            // Test widget
//            Button(action: {
////                let widgetViewController = WidgetViewController()
//                let window = WidgetWindow(WidgetView())
//                widgets.append(window)
//            }) {
//                Text("Test Widget")
//            }
//
//            Button(action: {
//                for widget in widgets {
//                    widget.clicked()
//                }
//            }) {
//                Text("Test click")
//                    .onHover { hover in
//                        print("Mouse hovering")}
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TabButton: View {
    var image: String
    var panel: Panel
    @Binding var selection: Panel
    @State var isHovered: Bool = false
    
    var defaultColor: Color = Color(NSColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
    var selectedColor: Color = .white
                                            
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.25)) {
                selection = panel
            }
        }) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(selection == panel || isHovered ? selectedColor : defaultColor)
                    .padding()
            }
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
    }
}

class SearchBarText: ObservableObject {
    @Published var text: String = ""
}

struct SearchBar: View {
    @EnvironmentObject var text: SearchBarText
    
    var body: some View {
        HStack {
            Image("search")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            TextField("Search for wallpapers/widgets/users", text: $text.text)
                .textFieldStyle(.plain)
                .focusable(false)
                .frame(width: 220)
        }
        .padding(10)
        .background(BlurEffect(material: .menu))
        .cornerRadius(20)
        .padding(.top, 15)
        .ignoresSafeArea()
        .frame(height: 55)
    }
}
