import SwiftUI

struct ProfileView: View {
    @Binding var loggedIn: Bool
    
    // Fetch user data from UserDefaults
    var firstName: String = UserDefaults.standard.string(forKey: "userFirstName") ?? "First Name"
    var lastName: String = UserDefaults.standard.string(forKey: "userLastName") ?? "Last Name"
    var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "Email"
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Profile Badge Card
                VStack(alignment: .leading, spacing: 15) {
                    Text("First Name: \(firstName)")
                    Text("Last Name: \(lastName)")
                    Text("Email: \(email)")
                }
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 10))
                
                // Log Out Button
                Button(action: {
                    loggedIn = false
                    UserDefaults.standard.set(false, forKey: "loggedIn")
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}
