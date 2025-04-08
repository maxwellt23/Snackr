//
//  SnackrToastModifier.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct SnackrToastModifier: ViewModifier {
    @Binding var message: String?
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
      content
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .overlay {
              ZStack {
                  ToastView()
                      .offset(y: -32)
              }
              .animation(.spring(), value: message)
          }
          .onChange(of: message) {
            showToast()
          }
    }

    @ViewBuilder func ToastView() -> some View {
        if let message {
            VStack {
                Spacer()
                
                SnackrToastView(message: message) {
                    dismissToast()
                }
            }
        }
    }

    private func showToast() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        workItem?.cancel()
      
        let task = DispatchWorkItem {
            dismissToast()
        }
      
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
    }

    private func dismissToast() {
        withAnimation {
            message = nil
        }

        workItem?.cancel()
        workItem = nil
    }
}
