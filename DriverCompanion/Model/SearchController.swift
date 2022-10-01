//
//  SearchController.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/25/22.
//

import Foundation
import MapKit

class SearchController: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText = ""
    @Published var searchResults = [MKLocalSearchCompletion]()
    
    @Published var mapItems = [MKMapItem]()
    @Published var showingMapItems = false
    @Published var selectedMapItem: MKMapItem?
    
    @Published var isSearching = false
    
    
    var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    func performSearch() {
        if searchText == "" {
            searchResults.removeAll()
        }
        
        searchCompleter.queryFragment = searchText
    }
    
    func performSearch(with completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error {
                print(error)
                return
            }
            
            guard let response else { return }
            self.mapItems = response.mapItems
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}
