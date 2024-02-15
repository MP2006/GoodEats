//
//  ProfilePage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI
import FirebaseAuth

struct ProfilePage: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var isLogoutAlertPresented = false
    @State private var shouldNavigateToLogin = false
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                .overlay(
        VStack {
            Text("User Profile")
                .font(.system(size: 40, weight: .bold, design: .serif))
                .padding()
                .foregroundColor(.white)
            
            // get data from Firebase for the current user, and display their name
            if let currentUser = userViewModel.currentUser {
                Text("\(currentUser.firstName) \(currentUser.lastName)")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding()
                    .foregroundColor(.white)
            }
            
            // have the option for the user to select a picture for their profile
            if let image = selectedImage{
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 300, height: 300)
            }
            else{
                Button("Add Profile Picture") {
                    isImagePickerPresented = true
                }
                .font(.system(size: 22, weight:.bold, design: .serif))
                .padding()
                .frame(width: 250, height: 50)
                .background(Color.white)
                .cornerRadius(8)
                .foregroundColor(.black)
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
                }
            }
            
            // implemented log out mechanism, make sure that all the data are clear and ready for next user to login
            Button("Logout") {
                isLogoutAlertPresented = true
            }
            .font(.system(size: 22, weight:.bold, design: .serif))
            .padding()
            .frame(width: 170, height: 50)
            .background(Color.white)
            .cornerRadius(8)
            .foregroundColor(.black)
            .alert(isPresented: $isLogoutAlertPresented) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .default(Text("Logout")) {
                        userViewModel.logout()
                            // Set the state variable to true to trigger NavigationLink
                        if userViewModel.currentUser == nil{
                            shouldNavigateToLogin = true
                        }
                    },
                    secondaryButton: .cancel()
                )
            }

            // NavigationLink to navigate back to the LoginPage
            .fullScreenCover(isPresented: $shouldNavigateToLogin) {
                LoginPage(userViewModel: UserViewModel())
            }
        }
            .navigationTitle("Profile")
            .padding()
        )
    }
    
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage(userViewModel: UserViewModel())
    }
}

