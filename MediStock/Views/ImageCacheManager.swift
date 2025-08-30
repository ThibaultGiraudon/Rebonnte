//
//  ImageCacheManager.swift
//  MediStock
//
//  Created by Thibault Giraudon on 27/08/2025.
//


import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private var cache = NSCache<NSURL, UIImage>()

    private init() {}

    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }

    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = image(for: url) {
            return cached
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        setImage(image, for: url)
        return image
    }
}

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var url: URL? {
        didSet {
            loadImage()
        }
    }
    
    private var cacheManager = ImageCacheManager.shared
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        Task {
            self.image = nil
            guard let url = url else { return }
            do {
                self.image = try await cacheManager.loadImage(from: url)
            } catch {
                self.image = nil
            }
        }
    }
}

struct FBImage<Content: View>: View {
    @ObservedObject var loader: ImageLoader
    var content: (Image) -> Content
    
    init(url: URL?, content: @escaping (Image) -> Content) {
        self.loader = ImageLoader(url: url)
        self.content = content
    }
    
    var body: some View {
        contentBody
    }

    @ViewBuilder
    private var contentBody: some View {
        if let image = loader.image {
            content(Image(uiImage: image))
        } else {
            ProgressView()
        }
    }
}

#Preview {
    FBImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/eventorias-df464.firebasestorage.app/o/events%2FA354ABA9-8FA2-46DE-B53D-4CFFB140DC5A.jpg?alt=media&token=4097459b-bbdc-4168-97ac-46a991ca331d")) { image in
            image
            .resizable()
    }
}