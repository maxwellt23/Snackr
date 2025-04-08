//
//  ImageCachingService.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

class ImageCachingService {
    private let folderName = "snackr_cached_images"
    private let fileManager: FileManagerProtocol
    
    init(fileManager: FileManagerProtocol = DefaultFileManager()) {
        self.fileManager = fileManager
        
        createFolderIfNeeded()
    }
    
    func cacheImage(with key: String, url: URL) async -> UIImage? {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data),
              let imageData = image.pngData(),
        let url = getImagePath(key: key) else {
            return nil
        }
        
        do {
            try fileManager.write(data: imageData, to: url)
            return image
        } catch {
            print("Error adding image to cache: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getCachedImage(with key: String) async -> UIImage? {
        guard let url = getImagePath(key: key) else {
            return nil
        }
        
        guard let data = fileManager.contents(atPath: url.path) else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    private func createFolderIfNeeded() {
        guard let url = getCacheFolderPath() else { return }
        
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print("Error creating cache folder: \(error.localizedDescription)")
            }
        }
    }
    
    private func getCacheFolderPath() -> URL? {
        fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL? {
        guard let folder = getCacheFolderPath() else {
            return nil
        }
        
        return folder.appendingPathComponent(key + ".png")
    }
}
