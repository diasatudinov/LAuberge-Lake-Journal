//
//  DownsampledFileImageView.swift
//  LAuberge Lake Journal
//
//


import SwiftUI

struct DownsampledFileImageView: View {
    let fileURL: URL?
    let cacheID: String
    var contentMode: ContentMode = .fill

    @StateObject private var loader = FileImageLoader()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let ui = loader.image {
                    Image(uiImage: ui)
                        .resizable()
                } else {
                }
            }
            .clipped()
            .onAppear {
                guard let url = fileURL else { return }
                let size = geo.size
                let key = "\(cacheID)_\(Int(size.width))x\(Int(size.height))"
                loader.load(url: url, targetSize: size, cacheKey: key)
            }
            .onDisappear {
                loader.cancel()
            }
            .onChange(of: cacheID) { _ in
                guard let url = fileURL else { return }
                loader.load(url: url, targetSize: geo.size, cacheKey: cacheID + "_\(Int(geo.size.width))x\(Int(geo.size.height))")
            }
            .onChange(of: fileURL?.path ?? "") { _ in
                guard let url = fileURL else { return }
                loader.load(url: url, targetSize: geo.size, cacheKey: cacheID + "_\(Int(geo.size.width))x\(Int(geo.size.height))")
            }
        }
    }
}

func imageURL(for fileName: String) -> URL? {
    // Вставь сюда свой путь (ApplicationSupport/Images/...)
    let fm = FileManager.default
    let appSupport = try? fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let bundle = Bundle.main.bundleIdentifier ?? "App"
    return appSupport?
        .appendingPathComponent(bundle, isDirectory: true)
        .appendingPathComponent("Images", isDirectory: true)
        .appendingPathComponent(fileName)
}
