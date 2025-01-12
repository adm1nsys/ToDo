//
//  LoadScreenView.swift
//  ToDo
//
//  Created by Admin Pro on 1/5/25.
//

import SwiftUI

struct LoadScreenView: View {
    
    var onFinish: () -> Void
    
    // MARK: - Animatable States
    
    /// Opacity of the background rectangle
    @State private var bgRectangleOpacity: Double = 1.0
    
    /// Opacity of the "ToDo" text
    @State private var hideToDo = false
    
    /// Offset of the second VStack moving downward
    @State private var moveOutVStack = false
    
    /// Scale of the large image `Image("Image")`
    @State private var bigImageScale: CGFloat = 1.0
    
    /// Opacity of the large image
    @State private var bigImageOpacity: Double = 1.0
    
    /// Opacity of the BlurView
    @State private var blurOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // MARK: - Blurred Background
            BlurView(style: .systemUltraThinMaterial)
                .opacity(blurOpacity)               // Smooth opacity animation for BlurView
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - A rectangle that fades out smoothly
            Rectangle()
                .fill(Color("BG"))
                .opacity(bgRectangleOpacity)
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - "ToDo" Text
            ZStack {
                Rectangle().fill(Color.clear)
                Text("ToDo")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 43)
                    .padding(.bottom, 20)
                    .padding(.bottom, 164.0)
                    .opacity(hideToDo ? 0 : 1) // Smooth fade-out animation
            }
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - VStack with Git logo and text
            VStack {
                Spacer()
                Image("Git")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72, height: 72)
                    .clipped()
                    .frame(maxWidth: .infinity)

                Spacer().frame(height: 8)

                Text("github.com/adm1nsys")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
            }
            // Offset the entire VStack downward during animation
            .offset(y: moveOutVStack ? UIScreen.main.bounds.height : 0)
            
            // MARK: - Large Image "Image"
            ZStack {
                Rectangle().fill(Color.clear)
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .scaleEffect(bigImageScale)   // Animation for scaling
                    .opacity(bigImageOpacity)     // Animation for fading out
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            // Step 1: Gradually hide the rectangle over 1.0 seconds
            withAnimation(.easeInOut(duration: 1.0)) {
                bgRectangleOpacity = 0
            }
            
            // Step 2: After 1.0 seconds, hide "ToDo"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    hideToDo = true
                }
            }
            
            // Step 3: After 2.0 seconds, slide the VStack downward
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    moveOutVStack = true
                }
            }
            
            // Step 4: After 3.5 seconds, scale up and hide the large image,
            //         and simultaneously fade out the BlurView
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    bigImageScale = 3.0
                    bigImageOpacity = 0.0
                    blurOpacity = 0.0
                }
            }
        }
    }
}

#Preview {
    // Wrapper to replay LoadScreenView continuously
    CyclicLoadScreenPreview()
}

/// Wrapper to restart LoadScreenView after completion
struct CyclicLoadScreenPreview: View {
    @State private var showLoadScreen = true
    
    var body: some View {
        Group {
            if showLoadScreen {
                // Main loading screen
                LoadScreenView {
                    // When onFinish() is called in LoadScreenView,
                    // this changes the flag to false.
                    showLoadScreen = false
                }
            } else {
                // Show empty space (or any other content),
                // then restart the animation after a brief pause.
                Color.clear
                    .onAppear {
                        // Set a 1-second pause to allow for a "blink"
                        // Set to 0 for instant restart
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showLoadScreen = true
                        }
                    }
            }
        }
    }
}
