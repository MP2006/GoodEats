//
//  UserViewModel.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var authenticationError: String?
    @Published var places = [Place]()
    @Published var currEmail: String?
    
    //    init(places: [Place]) {
    //        self.places = places
    //    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Firebase authentication error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if result != nil {
                print("Firebase authentication successful")
                // Fetch user data after successful login
                self.currEmail = email
                self.fetchUserDataFromFirestore(username: email)
                self.fetchPlacesFromFirestore(username: email)
                //self.writePlacesToFirestore(username: email)
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    func registerAccount(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(false)
            } else if let user = result?.user {
                // Successfully created user, now write user data to Firestore
                let userData = ["firstName": firstName, "lastName": lastName]
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(email)
                
                userRef.setData(userData) { error in
                    if let error = error {
                        print("Error writing user data to Firestore: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        // User registration and data writing successful
                        self.currentUser = User(email: email, firstName: firstName, lastName: lastName)
                        completion(true)
                    }
                }
            }
        }
    }
    
    func doesEmailExist(email: String) -> Bool {
        var emailExists = false
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Check if a user with the given email already exists
        usersCollection
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking email existence: \(error.localizedDescription)")
                    return
                }
                
                if let documents = snapshot?.documents, !documents.isEmpty {
                    // User with the given email already exists
                    emailExists = true
                }
            }
        
        return emailExists
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("im out")
            currentUser = nil
            currEmail = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func fetchUserDataFromFirestore(username: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(username)
        
        userRef.getDocument { document, error in
            if let error = error {
                // Handle Firestore document retrieval error
                print("Firestore document retrieval error: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                // Document found, retrieve user data
                let userData = document.data()
                let firstName = userData?["firstName"] as? String ?? ""
                let lastName = userData?["lastName"] as? String ?? ""
                
                print("First Name: \(firstName), Last Name: \(lastName)")
                
                // Update the currentUser property
                self.currentUser = User(email: username, firstName: firstName, lastName: lastName)
            } else {
                // Document not found, handle accordingly
                print("User not found in Firestore")
            }
        }
    }
    
    func fetchPlacesFromFirestore(username: String) {
        // Use Firebase to fetch places from the "places" collection
        // Update the "places" state variable with the fetched data
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(username)
        userRef.collection("places").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching places: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.places = documents.compactMap { document in
                do {
                    let place = try document.data(as: Place.self)
                    return place
                } catch {
                    print("Error decoding place: \(error.localizedDescription)")
                    return nil
                }
            }
            self.places.sort { $0.score > $1.score }
        }
    }
    
    func writePlaceToFirestore(place: Place) {
        let firestore = Firestore.firestore()
        let userRef = firestore.collection("users").document(currEmail!)
        print(currEmail!)
        //let placesCollection = userDocument.collection("places")
        userRef.collection("places").addDocument(data: [
            "name": place.name,
            "latitude": place.latitude,
            "longitude": place.longitude,
            "score": place.score,
            "description": place.description
        ]) { error in
            if let error = error {
                print("Error writing place to Firestore: \(error.localizedDescription)")
            } else {
                self.fetchPlacesFromFirestore(username: self.currEmail!)
                print("Place successfully written to Firestore")
            }
        }
    }
    
    // some trouble accessing the documentID
    func deletePlaceFromFirestore(place: Place?) {
        guard let place = place else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currEmail!)
        let placeDocRef = userRef.collection("places").document(place.id.uuidString)
        userRef.collection("places").document("mGz2GEcPSV8Dx6eBCsmS").delete { error in
            if let error = error {
                print("Error deleting place from Firestore: \(error.localizedDescription)")
            } else {
                print("Place successfully deleted from Firestore")
                self.places.removeAll { $0.id == place.id }
            }
        }
        self.fetchPlacesFromFirestore(username: self.currEmail!)
    }
    
    //    var sortedPlaces: [Place] {
    //            return places.sorted { $0.score > $1.score }
    //        }
    //    private func writePlacesToFirestore(username: String) {
    //        let firestore = Firestore.firestore()
    //        let userDocument = firestore.collection("users").document(username)
    //        let placesCollection = userDocument.collection("places")
    //        print("hiii")
    //        print(places)
    //        for place in places {
    //            placesCollection.addDocument(data: [
    //                "name": place.name,
    //                "latitude": place.coordinate.latitude,
    //                "longitude": place.coordinate.longitude,
    //                "score": place.score,
    //                "description": place.description
    //            ]) { error in
    //                if let error = error {
    //                    print("Error writing place to Firestore: \(error.localizedDescription)")
    //                } else {
    //                    print("Place successfully written to Firestore")
    //                }
    //            }
    //        }
    //    }
}

