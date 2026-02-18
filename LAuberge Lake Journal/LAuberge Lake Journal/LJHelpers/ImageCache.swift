//
//  ImageCache.swift
//  LAuberge Lake Journal
//
//


import UIKit
import ImageIO

// MARK: - Downsample
func downsampledImage(at url: URL, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    let oversample: CGFloat = 2.0   
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale * oversample

    let sourceOptions: CFDictionary = [
        kCGImageSourceShouldCache: false
    ] as CFDictionary

    guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { return nil }

    let downsampleOptions: CFDictionary = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: Int(maxDimensionInPixels)
    ] as CFDictionary

    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { return nil }
    return UIImage(cgImage: cgImage)
}

// MARK: - Cache
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}

    func get(_ key: String) -> UIImage? { cache.object(forKey: key as NSString) }
    func set(_ image: UIImage, for key: String) { cache.setObject(image, forKey: key as NSString) }
}
