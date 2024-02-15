//
//  EditPlacePage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/6/23.
//

import SwiftUI
import FirebaseFirestore

struct EditPlacePage: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userViewModel: UserViewModel
    private var place: Place?
    @State private var name: String
    @State private var latitude: String
    @State private var longitude: String
    @State private var score: Double
    @State private var description: String
    
    // init the place that we will use
    init(userViewModel: UserViewModel, place: Place? = nil) {
        _userViewModel = ObservedObject(initialValue: userViewModel)
        self.place = place
        _name = State(initialValue: place?.name ?? "")
        _latitude = State(initialValue: place?.latitude.description ?? "")
        _longitude = State(initialValue: place?.longitude.description ?? "")
        _score = State(initialValue: place?.score ?? 0.0)
        _description = State(initialValue: place?.description ?? "")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("Name", text: $name)
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("Longitute", text: $longitude)
                    .keyboardType(.decimalPad)
                // adding slider to select the score
                HStack {
                    Text("Score: \(String(format: "%.1f", score))")
                        .padding(.trailing, 8)
                    Slider(value: $score, in: 0.0...10.0, step: 0.1)
                }
                TextField("Comment", text: $description)
                Spacer()
            }
            .navigationTitle(place == nil ? "New Place" : "Edit Place")
            .padding()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        if place != nil{
                            editPlace()
                        }
                        else{
                            savePlace()
                        }
                        
                    }
                    .disabled(name.isEmpty || latitude.isEmpty || longitude.isEmpty)
                }
                
                if let _ = place {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Delete") {
                            deletePlace()
                        }
                    }
                }
            }
        }
    }
    // function that will call from userViewModel to update the database
    private func savePlace() {
        guard let latitudeDouble = Double(latitude),
              let longitudeDouble = Double(longitude) else {
            return
        }
        
        // use the entry to create a new Place
        let editedPlace = Place(
            name: name,
            latitude: latitudeDouble,
            longitude: longitudeDouble,
            score: score,
            description: description
        )
        userViewModel.writePlaceToFirestore(place: editedPlace)
        dismiss()
    }
    
    private func deletePlace(){
        userViewModel.deletePlaceFromFirestore(place: place!)
        dismiss()
    }
    
    // function that will call from userViewModel to update the database
    private func editPlace(){
        guard let latitudeDouble = Double(latitude),
              let longitudeDouble = Double(longitude) else {
            return
        }
        
        let editedPlace = Place(
            name: name,
            latitude: latitudeDouble,
            longitude: longitudeDouble,
            score: score,
            description: description
        )
        userViewModel.deletePlaceFromFirestore(place: place!)
        userViewModel.writePlaceToFirestore(place: editedPlace)
        dismiss()
        
    }
}

#Preview {
    EditPlacePage(userViewModel: UserViewModel())
}
