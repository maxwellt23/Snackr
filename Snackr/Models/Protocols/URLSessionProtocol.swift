//
//  URLSessionProtocol.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import Foundation

protocol URLSessionProtocol {
    var url: String { get }
    
    init(url: String)
    
    func contentsOf(url: URL) throws -> Data
}
