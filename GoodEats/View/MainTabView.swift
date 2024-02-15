//
//  MainTabView.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var userViewModel = UserViewModel()

        var body: some View {
            TabView {
                ProfilePage(userViewModel: userViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                
                MapPage(userViewModel: userViewModel)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                
                ListPage(userViewModel: userViewModel)
                    .tabItem {
                        Label("My List", systemImage: "list.bullet")
                    }
            }
            .environmentObject(userViewModel)
        }
}

#Preview {
    MainTabView()
}
