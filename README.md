# GoodEats - A Personalized Restaurant Experience Tracker

## Overview

GoodEats is a comprehensive iOS application designed for food enthusiasts to catalog their dining experiences. With GoodEats, users can effortlessly keep track of the restaurants they've visited, rate individual dishes, and visually document their culinary journeys. Leveraging the power of MapKit and Core Location, the app offers a dynamic map view for easy location tracking, while Firebase ensures secure user login and data storage. Additionally, integration with the Yelp API enriches the app with external restaurant ratings, making GoodEats a one-stop solution for managing and sharing your gastronomic adventures.

## Features

### User Authentication
- **Secure Login:** Users can create and manage their accounts securely, with Firebase handling authentication.

### Map View
- **Restaurant Locations:** Users can view their visited restaurants on a map, marked with pins for easy navigation.
- **Proximity Awareness:** Utilizes the user's current location to display distances to various restaurants.

### Restaurant Reviews
- **List View:** A sortable list of visited restaurants, organized by user reviews.
- **Add/Remove Restaurants:** Users have the flexibility to update their list as their experiences grow.
- **Review System:** Users can score restaurants and dishes on a scale of 1 to 10, adding personal comments for each.

### Dish Reviews
- **Detailed Dish Catalog:** For each restaurant, users can list the dishes they've tried, along with their reviews.
- **Photo Uploads:** Both restaurant and dish reviews can be accompanied by photos, thanks to integration with PhotoKit.
- **CRUD Operations:** Users can add, edit, or delete their reviews and dish entries, offering complete control over their content.

### Integration with Yelp API
- **External Ratings:** Display the overall Yelp rating for each restaurant, providing a comprehensive view of each establishment.

## Technology Stack

- **Core Location and MapKit:** For real-time location tracking and map displays.
- **Firebase:** Used for user authentication, database storage, and backend services.
- **Yelp API:** To fetch and display ratings and reviews from Yelp for listed restaurants.
- **PhotoKit:** Allows users to upload and manage photos of restaurants and dishes.
