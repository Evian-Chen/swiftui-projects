//
//  EditView.swift
//  BucketList
//
//  Created by hpclab on 2025/4/1.
//

import SwiftUI

struct EditView: View {
    enum LodingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    var location: Location
    
    @State private var name: String
    @State private var description: String
    var onSave: (Location) -> Void
    
    @State private var loadingState = LodingState.loading
    @State private var pages = [Page]()
    
    func openInMaps(for page: Page) {
        let latitude = location.latitude
        let longitude = location.longitude
        if let url = URL(string: "https://maps.apple.com/?daddr=\(latitude),\(longitude)") {
            openURL(url)
        }
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://zh.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        
        guard let url = URL(string: urlString) else {
            print("Bad url: \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted { $0.title < $1.title }
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
            
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place Name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title).font(.headline) +
                            Text(": ") +
                            Text(page.description).italic()
                        }
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Button {
                                openInMaps(for: page)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(page.title).font(.headline)
                                    Text(page.description).italic()
                                }
                            }
                        }
                    case .failed:
                        Text("try gain")
                    }
                
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
