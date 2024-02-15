//
//  ListPage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI

struct ListPage: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay(
            NavigationView {
                // prompt the user to a different view when click on each entry
                List($userViewModel.places,
                     editActions: .delete) { $place in
                    NavigationLink(destination: EditPlacePage(userViewModel: userViewModel, place: place)) {
                        PlaceCell(place: place)
                    }
                }
                     .navigationTitle("Places List")
                     .background(Color.gray.opacity(0.3))
                     .toolbar {
                         // have the option for the user to add extra locations
                         ToolbarItem(placement: .navigationBarTrailing) {
                             NavigationLink(destination: EditPlacePage(userViewModel: userViewModel)) {
                                 Image(systemName: "plus")
                             }
                         }
                     }
                //.padding()
            }
                .padding(.bottom)
        )
    }
}

#Preview {
    ListPage(userViewModel: UserViewModel())
}
