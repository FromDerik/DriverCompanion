//
//  MainView.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/24/22.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        (lhs.latitude, lhs.longitude) == (rhs.latitude, rhs.longitude)
    }
    
    
}

struct MainView: View {
    @EnvironmentObject var searchController: SearchController
    @EnvironmentObject var locationManager: LocationManager
    @FocusState var searchBarFocused: Bool
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
//    @State private var mapItems = [MKMapItem]()
    @State private var trackingUserLocation = true
    
    @State private var isMusicViewOpen = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                MapView(coordinateRegion: $region, mapItems: $searchController.mapItems, trackingUserLocation: $trackingUserLocation)
                    .environmentObject(locationManager)
                    .ignoresSafeArea()
                    .safeAreaInset(edge: .bottom) {
                        EmptyView()
                            .frame(height: 100)
                    }
                    .onChange(of: locationManager.location) { location in
                        guard let location else { return }
                        region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
                    }
                
                if !searchController.isSearching {
                    MusicView(isOpen: $isMusicViewOpen)
                        .transition(.move(edge: .bottom))
                }
            }
            
            if !isMusicViewOpen {
                SearchView()
                    .environmentObject(searchController)
                    .transition(.move(edge: .top))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SearchController())
            .environmentObject(LocationManager())
    }
}
