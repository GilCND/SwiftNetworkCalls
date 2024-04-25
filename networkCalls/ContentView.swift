/* PLEASE READ:
    This is just a example of a network call.
    All struct and elements ARE placed here for educational purposes.
    In a real world development you SHOULD respect the project's design pattern like MVVM, MVC etc.
 */

import SwiftUI

struct ContentView: View {
    
    @State private var user: GitHubUser?
    
    var body: some View {
        //Dummy UI
        VStack(spacing: 30) {
            AsyncImage(url: URL(string: user?.avatarURL ?? "")) { image in
                image
                    .resizable()
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(.cyan)
            }
                .frame(width: 150, height: 150)
            
            Text(user?.login ?? "Login Information")
                .bold()
                .font(.title3)
            
            Text(user?.bio ?? "Bio Placeholder")
                .padding()
            
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch {
                print("Error fetching GitHub user:", error)
            }
        }
    }
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/GilCND" //String URL
        
        // This converts the String URL into a usable URL
        guard let URL = URL(string: endpoint) else {
            throw GitHubErrors.invalidURL
        }
        
        //This return a tuple of data and response
        let (data, response) = try await URLSession.shared.data(from: URL)
        
        //The response constais the statusCode. We are looking for 200 to 299 (Success)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw GitHubErrors.invalidResponse
        }
        
        //If everything goes well we can now work with the data
        do {
            let decoder = JSONDecoder()
            //Here we use the model we created (GitHubUser) to decode the data
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            // If there is an error decoding we throw this error
            throw GitHubErrors.invalidData
        }
        
    }
}

#Preview {
    ContentView()
}

//MODEL
struct GitHubUser: Codable {
    let login: String
    let avatarURL: String //The original data from GitHub is avatar_url so we need codingKeys
    let bio: String
    
    // We will use codingKeys when we have some differences between our model and the JSON
    enum CodingKeys: String, CodingKey {
        case login, bio
        case avatarURL = "avatar_url" //avart_url corresponds to the GitHub JSON
    }
}

//Basic Error handling
enum GitHubErrors: Error, CustomDebugStringConvertible {
    case invalidURL
    case invalidResponse
    case invalidData
    case userError
    
    var debugDescription: String {
        switch self {
        case .invalidURL:
            return "The URL you are trying to access is invalid."
        case .invalidResponse:
            return "The URL you are trying tro access returned an invalid response."
        case .invalidData:
            return "The data you are trying to parse had a decode error."
        case .userError:
            return "There was an error assigning the user object to a @State variable"
        }
    }
}
