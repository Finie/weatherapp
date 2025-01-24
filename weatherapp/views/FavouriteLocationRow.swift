//
//  FavouriteLocationRow.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

 import SwiftUI

struct FavouriteLocationRow: View {
    
    let location: LocationDataStore // Replace with your actual model type

 
    var body: some View {
        HStack {
            Text("\(location.name ?? "unavailable")")
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            NavigationLink(
                destination: LocationDetailView(location: location),
                label: {
                    if location.active {
                        Text("Active 📍")
                            .font(.caption)
                            .foregroundColor(.green)
                            .frame(alignment: .trailing)
                    }
                }
            )
            .padding(.leading, 10)
        }
    }
}
