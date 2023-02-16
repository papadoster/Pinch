//
//  ContentView.swift
//  Pinch
//
//  Created by Александр Карпов on 16.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Prroperty
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                //MARK: - PageImage
                
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                //MARK: - 1. Tap Gesture
                
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            withAnimation(.spring()) {
                                imageOffset = .zero
                                imageScale = 1
                            }
                        }
                    }
                
                //MARK: - 2. Drag Gesture
                
                    .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)) {
                                imageOffset = value.translation
                            }
                        })
                        .onEnded({ _ in
                            if imageScale <= 1 {
                                withAnimation(.spring()) {
                                    imageScale = 1
                                    imageOffset = .zero
                                }
                            }
                        })
                    )
                
            } //: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
        } //: Navigation
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
