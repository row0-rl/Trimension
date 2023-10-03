import SwiftUI
import AppKit
import AuthenticationServices
import GoTrue

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var prompt = ""
    
    func login() {
        Task {
            do {
                try await SupabaseProvider.shared.supabaseClient.auth.signIn(email: email, password: password)
            } catch {
                if let goTrueError = error as? GoTrueError {
                    if goTrueError.errorDescription == "Invalid login credentials" {
                        prompt = "Incorrect username or password"
                    }
                    else {
                        prompt = "Unknown error"
                    }
                } else {
                    prompt = "Unknown error"
                }
                print(error)
            }
        }

    }
    
    var body: some View {
        VStack {
            Text("Logo")
                .font(.title)
                .padding()
            Text("Welcome Back!")
                .font(.largeTitle)
                .fontWeight(.heavy)


            Group {
                TextField("", text: $email, prompt: Text("Email"))
                    .textFieldStyle(.plain)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black)
                    )
                    .frame(width: 270, height: 40)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black)
                    )
                    .frame(width: 270, height: 40)
                
                Text(prompt)
                    .foregroundStyle(.red)
                
                Button {
                    login()
                } label: {
                    Text("Sign in")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                        .fontWeight(.semibold)
                        .frame(width: 270, height: 44)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .buttonStyle(.borderless)
                .hoverCursor()
            }
            .onSubmit {
                login()
            }
            
            HStack {
                VStack {
                    Divider()
                }
                Text("OR")
                    .foregroundStyle(.gray)
                    .padding()
                VStack {
                    Divider()
                }
            }
            .frame(width: 270)
            
            Button {
                print("click")
            } label: {
                Label("Continue with Apple", systemImage: "apple.logo")
                    .foregroundColor(.black)
                    .font(.system(size: 19))
                    .fontWeight(.semibold)
                    .frame(width: 270, height: 44)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .buttonStyle(.borderless)
            .hoverCursor()
        }
        .frame(maxWidth: .infinity)
    }
}


struct RegisterView: View {
    @State var email = ""
    @State var password = ""
    @State var prompt = ""
    
    func register() {
        Task {
            do {
                try await SupabaseProvider.shared.supabaseClient.auth.signIn(email: email, password: password)
            } catch {
                if let goTrueError = error as? GoTrueError {
                    if goTrueError.errorDescription == "Invalid login credentials" {
                        prompt = "Incorrect username or password"
                    }
                    else {
                        prompt = "Unknown error"
                    }
                } else {
                    prompt = "Unknown error"
                }
                print(error)
            }
        }

    }
    
    var body: some View {
        VStack {
            Text("Logo")
                .font(.title)
                .padding()
            Text("Join Us!")
                .font(.largeTitle)
                .fontWeight(.heavy)


            Group {
                TextField("", text: $email, prompt: Text("Enter your email"))
                    .textFieldStyle(.plain)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.black)
                    )
                    .frame(width: 270, height: 40)
                
                Text(prompt)
                    .foregroundStyle(.red)
                
                Button {
                    register()
                } label: {
                    Text("Join")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                        .fontWeight(.semibold)
                        .frame(width: 270, height: 44)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .buttonStyle(.borderless)
                .hoverCursor()
            }
            .onSubmit {
                register()
            }
            
            HStack {
                VStack {
                    Divider()
                }
                Text("OR")
                    .foregroundStyle(.gray)
                    .padding()
                VStack {
                    Divider()
                }
            }
            .frame(width: 270)
            
            Button {
                print("click")
            } label: {
                Label("Continue with Apple", systemImage: "apple.logo")
                    .foregroundColor(.black)
                    .font(.system(size: 19))
                    .fontWeight(.semibold)
                    .frame(width: 270, height: 44)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .buttonStyle(.borderless)
            .hoverCursor()
        }
        .frame(maxWidth: .infinity)
    }
}
