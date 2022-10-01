//
//  SearchView.swift
//  DriverCompanion
//
//  Created by Derik Malcolm on 9/24/22.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @EnvironmentObject var searchController: SearchController
    @FocusState var searchBarFocused: Bool
    @State private var searchBarHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            if searchController.isSearching {
                List(searchController.searchResults, id: \.self) { result in
                    VStack(alignment: .leading) {
                        Text(result.title)
                        Text(result.subtitle)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        searchController.mapItems.removeAll()
                        searchController.searchResults.removeAll()
                        searchBarFocused = false
                        searchController.performSearch(with: result)
                        searchController.showingMapItems = true
                    }
                }
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .top, content: {
                    EmptyView().frame(height: searchBarHeight)
                })
                .background(Rectangle().fill(.ultraThinMaterial))
                .edgesIgnoringSafeArea(.all)
                .transition(.move(edge: .bottom))
            }
            
            searchBar
                .background(GeometryReader { proxy -> Color in
                    DispatchQueue.main.async {
                        self.searchBarHeight = proxy.size.height + 10
                    }
                    return Color.clear
                })
                .shadow(radius: 10)
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("", text: $searchController.searchText, prompt: Text("Search"))
                .focused($searchBarFocused)
                .onChange(of: searchBarFocused) { newValue in
                    withAnimation {
                        searchController.isSearching = newValue || searchController.searchResults.count > 0
                    }
                }
                .onChange(of: searchController.searchText) { newValue in
                    searchController.performSearch()
                }
                .overlay(alignment: .trailing) {
                    if searchController.searchText != "" {
                        Button {
                            searchController.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundColor(.primary)
                    }
                }
        }
        .font(.title3)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.thinMaterial)
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SearchController())
    }
}
