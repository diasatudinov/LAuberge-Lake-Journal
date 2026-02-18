import UIKit

final class ImageStore {
    static let shared = ImageStore()
    private let fm = FileManager.default

    private init() {
        try? ensureFolder()
    }

    // MARK: - Save

    /// Сохраняет картинку в файл и возвращает имя файла
    func save(image: UIImage, id: UUID) throws -> String {
        try ensureFolder()

        let fileName = "\(id.uuidString).jpg"
        let url = fileURL(named: fileName)

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageStore", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to encode JPEG"])
        }

        try data.write(to: url, options: [.atomic])
        return fileName
    }

    // MARK: - Load

    func load(named fileName: String) -> UIImage? {
        let url = fileURL(named: fileName)
        return UIImage(contentsOfFile: url.path)
    }

    // MARK: - Delete

    func delete(named fileName: String?) {
        guard let fileName else { return }
        try? fm.removeItem(at: fileURL(named: fileName))
    }

    // MARK: - Paths

    private func ensureFolder() throws {
        let folder = try imagesFolderURL()
        if !fm.fileExists(atPath: folder.path) {
            try fm.createDirectory(at: folder, withIntermediateDirectories: true)
        }
    }

    private func imagesFolderURL() throws -> URL {
        // Лучше, чем Documents: не светится в Files и не бэкапится без нужды
        let appSupport = try fm.url(for: .applicationSupportDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: true)

        let bundle = Bundle.main.bundleIdentifier ?? "App"
        let base = appSupport.appendingPathComponent(bundle, isDirectory: true)
        if !fm.fileExists(atPath: base.path) {
            try fm.createDirectory(at: base, withIntermediateDirectories: true)
        }

        return base.appendingPathComponent("Images", isDirectory: true)
    }

    func fileURL(named fileName: String) -> URL {
        let folder = try! imagesFolderURL()
        return folder.appendingPathComponent(fileName)
    }
}