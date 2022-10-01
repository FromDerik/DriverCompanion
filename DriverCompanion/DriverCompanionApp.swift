//
//  DriverCompanionApp.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/24/22.
//

import SwiftUI

@main
struct DriverCompanionApp: App {
    @StateObject var searchController = SearchController()
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(searchController)
                .environmentObject(locationManager)
        }
    }
}
