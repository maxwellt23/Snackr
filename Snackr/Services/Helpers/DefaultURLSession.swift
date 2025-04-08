//
//  DefaultURLSession.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import Foundation

class DefaultURLSession: URLSessionProtocol {
    let url: String
    
    required init(url: String) {
        self.url = url
    }
    
    func contentsOf(url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
