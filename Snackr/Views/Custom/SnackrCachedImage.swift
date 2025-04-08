//
//  SnackrCachedImage.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct SnackrCachedImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: Image?
    
    let imageCachingService = ImageCachingService()
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let image {
                content(image)
            } else {
                placeholder()
            }
        }
        .onAppear {
            if let url {
                Task {
                    let key = url.pathComponents.suffix(2).joined(separator: "_")
                    
                    if let image = await imageCachingService.getCachedImage(with: key) {
                        DispatchQueue.main.async {
                            self.image = Image(uiImage: image)
                        }
                    } else {
                        if let image = await imageCachingService.cacheImage(with: key, url: url) {
                            
                            DispatchQueue.main.async {
                                self.image = Image(uiImage: image)
                            }
                        }
                    }
                }
            }
        }
    }
}
