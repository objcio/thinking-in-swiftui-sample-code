//
//  ContentView.swift
//  ImageLoading
//
//  Created by Chris Eidhof on 12.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

struct LoadingError: Error {}

final class Remote<A>: ObservableObject {
    @Published var result: Result<A, Error>? = nil // nil means not loaded yet
    var value: A? { try? result?.get() }
    
    let url: URL
    let transform: (Data) -> A?

    init(url: URL, transform: @escaping (Data) -> A?) {
        self.url = url
        self.transform = transform
    }

    func load() {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let d = data, let v = self.transform(d) {
                    self.result = .success(v)
                } else {
                    self.result = .failure(LoadingError())
                }
            }
        }.resume()
    }
}

struct Photo: Codable, Identifiable {
    var id: String
    var author: String
    var width, height: CGFloat
    var url, download_url: URL
}

struct ContentView: View {
    @StateObject var items = Remote(
        url: URL(string: "https://picsum.photos/v2/list")!,
        transform: { try? JSONDecoder().decode([Photo].self, from: $0) }
    )
    
    var body: some View {
        NavigationView {
            if let photos = items.value {
                List(photos) { photo in
                    NavigationLink(photo.author, destination: PhotoView(photo.download_url, aspectRatio: photo.width/photo.height))
                }
            } else {
                ProgressView()
                    .onAppear { items.load() }
            }
        }
    }
}

struct PhotoView: View {
    @ObservedObject var image: Remote<UIImage>
    var aspectRatio: CGFloat
    
    init(_ url: URL, aspectRatio: CGFloat) {
        image = Remote(url: url, transform: { UIImage(data: $0) })
        self.aspectRatio = aspectRatio
    }
    
    var imageOrPlaceholder: Image {
        image.value.map(Image.init) ?? Image(systemName: "photo")
    }

    var body: some View {
        imageOrPlaceholder
            .resizable()
            .foregroundColor(.secondary)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .padding()
            .onAppear { image.load() }
    }
}
