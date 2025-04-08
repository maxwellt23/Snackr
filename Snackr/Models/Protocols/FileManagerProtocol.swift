//
//  FileManagerProtocol.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import Foundation

protocol FileManagerProtocol {
    func fileExists(atPath path: String) -> Bool
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool) throws
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    
    func write(data: Data, to url: URL) throws
    
    func contents(atPath path: String) -> Data?
    
    func fetchImageData(from url: URL) -> Data?
}
