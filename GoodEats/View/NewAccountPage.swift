//
//  NewAccountPage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI

struct NewAccountPage: View {
    // create entries for user to enter their information for a new account
    @State private var email = ""
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var password = ""
    @State private var isMatchPassword = false
    @State private var confirmpassword = ""

    @ObservedObject var userViewModel: UserViewModel
    @State private var navigateToLoginPage = false
    @State private var navigateToMainTabView = false
    
    // use to create new account, ask the user to fill in informations
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
                        
                        TextField("First Name", text: $firstname)
                            .font(.system(size: 20, design: .serif))
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        
                        TextField("Last Name", text: $lastname)
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
                        
                        SecureField("Confirm Password", text: $confirmpassword)
                            .font(.system(size: 20, design: .serif))
                            .padding()
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        // have methods within the Button to check if the condition is good to create an account
                        Button("Create Account") {
                            // Check if password and confirm password match
                                guard password == confirmpassword else {
                                    // Show an alert or handle the mismatch
                                    isMatchPassword = true
                                    return
                                }
                            userViewModel.registerAccount(email: email, password: password, firstName: firstname, lastName: lastname) { success in
                                if success {
                                    // Registration successful, navigate to the desired page
                                    navigateToMainTabView = true
                                }
                            }
                        }
                        .font(.system(size: 22, weight:.bold, design: .serif))
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                        
                        Button("Return To Sign In"){
                            navigateToLoginPage = true
                        }
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        
                }
                .padding()
        )
        .fullScreenCover(isPresented: $navigateToLoginPage) {
            LoginPage(userViewModel: UserViewModel())
        }
        .fullScreenCover(isPresented: $navigateToMainTabView){
            MainTabView(userViewModel: userViewModel)
        }
        // alert to make sure the passwords are match
        .alert(isPresented: $isMatchPassword) {
            Alert(title: Text("Password Mismatch"), message: Text("Password and confirm password do not match. Please try again."), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NewAccountPage(userViewModel: UserViewModel())
}
