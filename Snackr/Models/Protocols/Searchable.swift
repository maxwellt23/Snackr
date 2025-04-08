//
//  Searchable.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import Foundation

protocol Searchable {
    func searchableStringProperties() -> [String]
}

extension Array where Element: Searchable {
    func filter(with searchText: String, minCharacters: Int = 1) -> [Element] {
        let cleanedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedSearchText.isEmpty, cleanedSearchText.count >= minCharacters else {
            return self
        }
        
        return self.filter { item in
            let stringProperties = item.searchableStringProperties()
            
            return stringProperties.contains { property in
                property.localizedCaseInsensitiveContains(cleanedSearchText)
            }
        }
    }
}
