//
//  MapPage.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import SwiftUI
import MapKit
import CoreLocation

// get location authorization to use for the app
// also use this class to update userLocation state as well
class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else {
            return
        }
        
        // Update userLocation state
        userLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            // Handle denied authorization
        }
    }
}

//let places = [
//    Place(
//        name: "Hangari Kalguksu",
//        coordinate: CLLocationCoordinate2D(
//            latitude: 34.0630875801614,
//            longitude: -118.29750556930868
//        ), score: 9.0, description: "great Korean food"
//    ),
//    Place(
//        name: "Guerrilla Tacos",
//        coordinate: CLLocationCoordinate2D(
//            latitude: 34.03455574238812,
//            longitude: -118.23211085011799
//        ), score: 7.0, description: "nice taco"
//    ),
//    Place(
//        name: "Blue Bottle Coffee",
//        coordinate: CLLocationCoordinate2D(
//            latitude: 34.03934170715321,
//            longitude: -118.23262457652926
//        ), score: 5.0, description: "meh coffee"
//    )
//]

struct MapPage: View {
    @StateObject private var locationDelegate = LocationDelegate()
    private let locationManager = CLLocationManager()
    @ObservedObject var userViewModel: UserViewModel
    @State private var selectedPlace: Place?
    @State private var isShowingDetails = false
    
    // preset location to around USC area
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 34.02228881586384,
            longitude: -118.2854678997811
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay(
            ZStack(alignment: .bottomTrailing) {
                // using a loop to initiate all the pin on the map
                // use methods to get the coordinate from difference places
                Map(coordinateRegion: $region, annotationItems: userViewModel.places) { place in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: CLLocationDegrees(place.latitude),
                        longitude: CLLocationDegrees(place.longitude)
                    )) {
                        VStack {
                            // design for the pin
                            Circle()
                                // pin will have different color based on the writing
                                .fill(circleColor(for: place.score))
                                .frame(height: 25)
                                .overlay(
                                    Text(String(format: "%.1f", place.score))
                                        .font(.system(size: 12, weight: .bold, design: .serif))
                                        .foregroundColor(.white)
                                )
                            Text(place.name)
                                .font(.system(size: 10, weight: .bold, design: .serif))
                        }
                        .onTapGesture {
                            selectedPlace = place
                            isShowingDetails = true
                        }
                    }
                }
                .onChange(of: selectedPlace) { newSelectedPlace in
                    // Use onChange to monitor changes to selectedPlace and present the sheet accordingly
                    if newSelectedPlace != nil {
                        isShowingDetails = true
                    }
                }
                // display more information when the user clicked on the pin
                .sheet(isPresented: $isShowingDetails) {
                    if let selectedPlace = selectedPlace {
                        PlaceDetailPage(place: selectedPlace)
                    }
                }
                
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    // Request location permissions and start updating the user's location
                    locationManager.delegate = locationDelegate
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
                }
                
                
                Button(action: {
                    // Recenter the map on the user's current location
                    if let userLocation = locationDelegate.userLocation {
                        region.center = userLocation
                    }
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                        )
                }
                .padding()
            }
                .padding(.bottom)
        )
    }
    
    // give color to the circle based on the rating
    private func circleColor(for score: Double) -> Color {
        switch score {
        case 8...10:
            return .green
        case 6..<8:
            return .yellow
        default:
            return .red
        }
    }
}

// design for the page when the user click on the pin
struct PlaceDetailPage: View {
    let place: Place
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.red, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .overlay(
            VStack {
                Text("Place Details")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .padding()
                    .foregroundColor(.white)
                
                Text("Name: \(place.name)")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding()
                    .foregroundColor(.white)
                
                Text(String(format: "Score: %.1f", place.score))
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding()
                    .foregroundColor(.white)
                
                Text("My Comment: \(place.description)")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .padding()
                    .foregroundColor(.white)
                
                Spacer()
            }
        )
        
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage(userViewModel: UserViewModel())
    }
}






