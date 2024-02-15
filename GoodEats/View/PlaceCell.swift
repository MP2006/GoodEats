//
//  PlaceCell.swift
//  GoodEats
//
//  Created by Minh Pham on 12/6/23.
//

import SwiftUI

// create how each cell will be when display as a list
struct PlaceCell: View {
    let place: Place
    var body: some View {
        VStack(alignment: .leading) {
            Text(place.name)
                .font(.headline)
            Text(String(format: "Score: %.1f", place.score))
                .font(.subheadline)
                .foregroundColor(scoreColor(for: Float(place.score)))
        }
    }
    
    // different color for different score
    private func scoreColor(for score: Float) -> Color {
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

#Preview {
    PlaceCell(
        place:
            Place(name: "Mama Lu", latitude: 41.234123, longitude: 41.234123, score: 9.2, description: "SO GOOD")
    )
}
