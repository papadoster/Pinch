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
    @State private var endDragOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    func resetImageState() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
            endDragOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                //MARK: - PageImage
                
                Image(currentPage())
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
                            resetImageState()
                        }
                    }
            }
            
            //MARK: - 2. Drag Gesture
            
            .gesture(
                DragGesture()
                    .onChanged({ gesture in
                        withAnimation(.linear(duration: 1)) {
                            imageOffset = CGSize(width: gesture.translation.width + endDragOffset.width, height: gesture.translation.height + endDragOffset.height)
                        }
                    })
                    .onEnded({ gesture in

                        if (imageScale <= 1) {
                            resetImageState()
                        }
                        else {
                            endDragOffset = CGSize(width: gesture.translation.width + endDragOffset.width, height: gesture.translation.height + endDragOffset.height)
                        }
                    })
            )
            
            //MARK: - 3. MagnificationGesture
            
            .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        
                        withAnimation(.linear(duration: 1)) {
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                                
                            } else if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    })
                    .onEnded({ _ in
                        if imageScale > 5 {
                            imageScale = 5
                        } else if imageScale <= 1 {
                            resetImageState()
                        }
                    })
            )
            
            //: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            
            //MARK: - Controls
            
            .overlay(
                Group {
                    HStack {
                        
                        // scale down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControllImageView(icon: "minus.magnifyingglass")
                        }
                        
                        
                        // reset
                        
                        Button {
                            resetImageState()
                        } label: {
                            ControllImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // scale up
                        
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControllImageView(icon: "plus.magnifyingglass")
                        }
                        
                    } //: Conrolls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            //MARK: - DRAWER
            
            .overlay(
                HStack(spacing: 12) {
                    
                    //MARK: - DRAWER HANDLE
                    
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    //MARK: - THUMBNAILS
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    Spacer()
                    
                    
                } //: DRAWER
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
        } //: Navigation

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
