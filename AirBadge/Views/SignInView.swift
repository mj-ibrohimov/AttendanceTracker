import SwiftUI

struct SignInView: View {
    @Binding var loggedIn: Bool
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if isSignUp {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: signUp) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            } else {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: login) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Button(action: {
                    isSignUp.toggle()
                    errorMessage = ""
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                
            }

            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.top, 10)
        }
        .padding()
    }
    
    private func signUp() {
        if password == confirmPassword {
            // Store the user data in UserDefaults
            UserDefaults.standard.set(firstName, forKey: "userFirstName")
            UserDefaults.standard.set(lastName, forKey: "userLastName")
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(true, forKey: "loggedIn")
            loggedIn = true
        } else {
            errorMessage = "Passwords do not match"
        }
    }
    
    private func login() {
        if let storedEmail = UserDefaults.standard.string(forKey: "userEmail"),
           let storedPassword = UserDefaults.standard.string(forKey: "userPassword"), email == storedEmail && password == storedPassword {
            UserDefaults.standard.set(true, forKey: "loggedIn")
            loggedIn = true
        } else {
            errorMessage = "Invalid email or password"
        }
    }
}
