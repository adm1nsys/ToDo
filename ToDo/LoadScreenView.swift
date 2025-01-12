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

// MARK: - Preview

struct LoadScreenViewPreviewWrapper: View {
    @State private var showLoadScreen = false
    @State private var reloadToggle = false

    var body: some View {
        ZStack {
            
            ContentView(
                notificationService: NotificationService(
                    tasks: [
                        Task(title: "Sample Task 1", description: "Description 1", deadline: Date().addingTimeInterval(3600), isCompleted: false),
                        Task(title: "Sample Task 2", description: "Description 2", deadline: Date().addingTimeInterval(7200), isCompleted: true)
                    ],
                    reminderEnabled: true
                )
            )
            .environmentObject(AppSettings())
            
            if showLoadScreen {
                    Button("Double click to restart") {
                        reloadToggle.toggle()
                    }
            }

            if reloadToggle {
                if showLoadScreen {
                    LoadScreenView {
                        showLoadScreen = false
                    }
                }
            }
        }
        .onChange(of: showLoadScreen) { newValue in
            
            if !newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showLoadScreen = true
                }
            }
        }
        .onAppear{
            reloadToggle = true
            showLoadScreen = true
        }
    }
}

struct LoadScreenView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        LoadScreenViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("Load Screen 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        LoadScreenViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Load Screen 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        LoadScreenViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("Load Screen SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        LoadScreenViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Load Screen SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}
