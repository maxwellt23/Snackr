//
//  SnackrImageView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/8/25.
//

import SwiftUI

struct SnackrImageView: View {
    let url: String?
    let size: CGSize
    
    var body: some View {
        SnackrCachedImage(url: URL(string: url ?? "")) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: size.width > 50 ? 0 : 8))
        } placeholder: {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("Neutral").opacity(0.25))
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: size.width > 50 ? 0 : 8))
        }
    }
}
