//
//  LoginPage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    var currentUser: User?
    @ObservedObject var userViewModel: UserViewModel
    @State private var navigateToMainTabView = false
    @State private var navigateToNewAccountPage = false
    @State private var showAlert = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack (spacing: 20){
                        Text("GoodEats")
                            .font(.system(size: 50, weight: .bold, design: .serif))
                            .padding()
                            .foregroundColor(.white)
                        
                        TextField("Email", text: $email)
                            .font(.system(size: 20, design: .serif))
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 20, design: .serif))
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        Button("Login") {
                            loginUser()
//                            if userViewModel.currentUser != nil{
//                                navigateToMainTabView = true
//                            }
                            //navigateToMainTabView = true
                        }
                        .font(.system(size: 22, weight:.bold, design: .serif))
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        
                        Button("New Account"){
                            navigateToNewAccountPage = true
                        }
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                        Text("or")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            //.padding()
                            .foregroundColor(.white)
                        
                        Button("Sign-in With Google") {
//                            Task {
//                                await loginUser()
//                            }
                            navigateToMainTabView = true
                        }
                        .font(.system(size: 18, weight:.bold, design: .serif))
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                .padding()
        )
        // depends on the user choices, the app will prompt the user to the correct view
        .fullScreenCover(isPresented: $navigateToMainTabView) {
            MainTabView(userViewModel: userViewModel)
        }
        .fullScreenCover(isPresented: $navigateToNewAccountPage) {
            NewAccountPage(userViewModel: UserViewModel())
        }
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Failed"),
                        message: Text("Incorrect email or password. Please try again."),
                        dismissButton: .default(Text("OK"))
                    )
                }
    }

//    private func loginUser() async {
//        do {
//            print("checking")
//            guard !email.isEmpty, !password.isEmpty else {
//                print("Email and password cannot be empty.")
//                return
//            }
//            
//            let authResult = try await Auth.auth().signIn(
//                withEmail: email,
//                password: password
//            )
//            navigateToMainTabView = true
//
//            // Firebase authentication successful
//            print("Firebase authentication successful")
//
//            // Create a User instance with relevant data
//            let user = User(email: authResult.user.uid,
//                            firstName: "", // Add logic to fetch first name from Firestore if needed
//                            lastName: "")  // Add logic to fetch last name from Firestore if needed
//
//            // Fetch user data from Firestore after successful login
//            await fetchUserDataFromFirestore(username: user.email)
//        } catch {
//            // Handle Firebase authentication error
//            print("Firebase authentication error: \(error.localizedDescription)")
//        }
//    }
    
    // call login method from userViewModel
    private func loginUser(){
        userViewModel.login(email: email, password: password) { result in
                switch result {
                case .success(let success):
                    if success {
                        // Login successful, navigate to the main tab view
                        navigateToMainTabView = true
                    } else {
                        // Login failed, set showAlert to true
                        showAlert = true
                    }
                case .failure(let error):
                    // Handle other types of errors, e.g., network issues
                    print("Login failed with error: \(error.localizedDescription)")
                }
            }
    }
    
//    private func signInWithGoogle() {
//        let googleSignIn = GIDSignIn.sharedInstance()
//        googleSignIn?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
//        googleSignIn?.signIn()
//    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage(userViewModel: UserViewModel())
    }
}
