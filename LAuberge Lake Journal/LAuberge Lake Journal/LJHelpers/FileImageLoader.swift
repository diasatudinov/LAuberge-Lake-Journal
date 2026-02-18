//
//  FileImageLoader.swift
//  LAuberge Lake Journal
//
//


import SwiftUI

@MainActor
final class FileImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var task: Task<Void, Never>?

    func load(url: URL, targetSize: CGSize, cacheKey: String) {
        if let cached = ImageCache.shared.get(cacheKey) {
            self.image = cached
            return
        }

        task?.cancel()
        task = Task.detached(priority: .utility) {
            let img = downsampledImage(at: url, to: targetSize)
            await MainActor.run {
                if let img {
                    ImageCache.shared.set(img, for: cacheKey)
                    self.image = img
                }
            }
        }
    }

    func cancel() { task?.cancel() }
}
