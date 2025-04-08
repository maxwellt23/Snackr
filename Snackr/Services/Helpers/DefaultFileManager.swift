//
//  DefaultFileManager.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import UIKit

class DefaultFileManager: FileManagerProtocol {
    let fileManager = FileManager.default
    
    func fileExists(atPath path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates)
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        fileManager.urls(for: directory, in: domainMask)
    }
    
    func write(data: Data, to url: URL) throws {
        try data.write(to: url)
    }
    
    func contents(atPath path: String) -> Data? {
        fileManager.contents(atPath: path)
    }
    
    func fetchImageData(from url: URL) -> Data? {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data),
              let imageData = image.pngData() else {
            return nil
        }
        
        return imageData
    }
}
