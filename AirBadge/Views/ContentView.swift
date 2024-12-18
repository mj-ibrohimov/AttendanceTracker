import SwiftUI

struct ContentView: View {
    @State private var loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    @State private var showProfile = false
    @State private var timeManager = TimeManager()

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                if !loggedIn {
                    SignInView(loggedIn: $loggedIn)
                } else {
                    VStack {
                        HStack {
                            Button(action: {
                                showProfile.toggle()
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 50)
                            .padding(.leading, 20)
                            
                            Spacer()
                        }

                        TimeSummaryView(timeSpentToday: timeManager.timeSpentToday, weeklyData: timeManager.weeklyData)
                            .padding(.top, 50)

                        Spacer()

                        TapButtonView(isTappedIn: timeManager.isTappedIn) {
                            if !timeManager.isTappedIn {
                                timeManager.tapInWithFaceID { success in
                                    if success {
                                        print("Tapped in")
                                    }
                                }
                            } else {
                                timeManager.tapOut()
                                print("Tapped out")
                            }
                        }
                        .padding(.bottom, 50)
                    }
                    .sheet(isPresented: $showProfile) {
                        ProfileView(loggedIn: $loggedIn)
                    }
                }
            }
        }
    }
}
