//
//  ContentView.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        //        NavigationView {
        //            if userViewModel.currentUser != nil {
        //                MainTabView(userViewModel: userViewModel)
        //            } else {
        //                LoginPage(userViewModel: userViewModel)
        //            }
        //        }
        //        .navigationViewStyle(StackNavigationViewStyle())
        // navigate to the login page when the user opened the app
        LoginPage(userViewModel: userViewModel)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userViewModel: UserViewModel())
    }
}
