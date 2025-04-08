//
//  MockFileManager.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import UIKit
@testable import Snackr

class MockFileManager: FileManagerProtocol {
    var directories: [String] = []
    var files: [String : Data] = [:]
    
    let mockDirectoryURL = URL(filePath: "/mock")
    
    func fileExists(atPath path: String) -> Bool {
        files[path] != nil
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws {
        directories.append(url.path())
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return [mockDirectoryURL]
    }
    
    func write(data: Data, to url: URL) throws {
        files[url.path()] = data
    }
    
    func contents(atPath path: String) -> Data? {
        files[path]
    }
    
    func fetchImageData(from url: URL) -> Data? {
        return UIImage(systemName: "star.fill")?.pngData()
    }
}
