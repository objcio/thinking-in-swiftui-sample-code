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
    var width, height: Int
    var url, download_url: URL
}

struct ContentView: View {
    @ObservedObject var items = Remote(
        url: URL(string: "https://picsum.photos/v2/list")!,
        transform: { try? JSONDecoder().decode([Photo].self, from: $0) }
    )
    
    var body: some View {
        return NavigationView {
            if items.value == nil {
                Text("Loading...")
                    .onAppear { self.items.load() }
            } else {
                List {
                    ForEach(items.value!) { photo in
                        NavigationLink(destination: PhotoView(photo.download_url), label: { Text(photo.author) })
                    }
                }
            }
        }
    }
}

struct PhotoView: View {
    @ObservedObject var image: Remote<UIImage>

    init(_ url: URL) {
        image = Remote(url: url, transform: { UIImage(data: $0) })
    }

    var body: some View {
        return Group {
            if image.value == nil {
                Text("Loading...").onAppear { self.image.load() }
            } else {
                Image(uiImage: image.value!)
                	.resizable()
                    .aspectRatio(image.value!.size, contentMode: .fit)
            }
        }
    }
}
