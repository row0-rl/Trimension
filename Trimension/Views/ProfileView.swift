import SwiftUI

struct ProfileView: View {
    let userId: UUID
    @State private var user: User?
    @State private var avatar = Image(systemName: "photo")
    
    var body: some View {
        HStack {
            avatar
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
            if let user = user {
                Text("Hello! \(user.name)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            // Sign out button
            Button {
                Task {
                    do {
                        try await SupabaseProvider.shared.supabaseClient.auth.signOut()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign out")
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .task {
            do {
                user = try await SupabaseProvider.shared.supabaseClient.database.from("user").select().match(query: ["id": userId]).single().execute().value
                if let user = user {
                    let data = try await SupabaseProvider.shared.supabaseStorageClient.from(id: "avatar").download(path: "avatar.jpeg")
                    if let nsImage = NSImage(data: data) {
                        avatar = Image(nsImage: nsImage)
                    } else {
                        print("Corrupted avatar image")
                    }
                }
            }
            catch {
                print("error: \(error)")
            }
        }
    }
}
