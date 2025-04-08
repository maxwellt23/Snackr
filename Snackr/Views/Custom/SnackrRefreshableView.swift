//
//  SnackrRefreshableView.swift
//  Snackr
//
//  Created by Tyler Maxwell on 4/7/25.
//

import SwiftUI

struct SnackrRefreshableView<Content: View>: View {
    let content: Content
    let showsIndicator: Bool
    
    let onRefresh: () async -> Void
    
    @StateObject private var scrollDelegate: ScrollDelegate = .init()
    
    init(showsIndicator: Bool = false, @ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> Void) {
        self.showsIndicator = showsIndicator
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicator) {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Group {
                        if scrollDelegate.isRefreshing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.down")
                                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                                .foregroundStyle(.white)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(8)
                    .background(Color("Accent"), in: .circle)
                    
                    Text("Pull to Refresh")
                        .font(.caption.bold())
                        .foregroundStyle(Color("PText"))
                }
                .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
                .frame(height: scrollDelegate.refreshHeight * scrollDelegate.progress)
                .opacity(scrollDelegate.progress)
                .offset(y: scrollDelegate.isEligible ? -max(0, scrollDelegate.contentOffset) : -max(0, scrollDelegate.scrollOffset))
                
                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                scrollDelegate.contentOffset = offset
                
                if !scrollDelegate.isEligible {
                    let progress = min(max(offset / scrollDelegate.refreshHeight, 0), 1)
                    
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) {
            if scrollDelegate.isRefreshing {
                Task {
                    try? await Task.sleep(for: .seconds(0.5))
                    await onRefresh()
                    
                    withAnimation(.easeInOut) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
}

class ScrollDelegate: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    
    let refreshHeight: CGFloat
    
    init(refreshHeight: CGFloat = 100) {
        self.refreshHeight = refreshHeight
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll()
    }
    
    private func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    @objc
    private func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            if !isRefreshing {
                isEligible = scrollOffset > refreshHeight
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
