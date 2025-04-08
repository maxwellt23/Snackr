//
//  SnackrToastView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct SnackrToastView: View {
    var message: String
    var onCancelTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.white)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                onCancelTapped()
            }) {
                Image(systemName: "xmark")
                    .foregroundStyle(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("Error"), in: .rect(cornerRadius: 8))
        .padding(.horizontal, 15)
    }
}
