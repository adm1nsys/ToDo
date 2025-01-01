//
//  Background.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).fill(Color("BG")).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            RoundedRectangle(cornerRadius: 0).fill(Color.gray).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).opacity(0.1)
            GeometryReader{ geometry in
                VStack{
                    
                    HStack {
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2).blur(radius: 50)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/1.5).blur(radius: 50)
                    }
                    Spacer()
                    HStack {
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/1.3).blur(radius: 50)
                        Spacer()
                    }
                    
                }.opacity(1)
                
                VStack{
                    
                    HStack {
                        Spacer()
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2.3).blur(radius: 50)
                    }
                    HStack {
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2.5).blur(radius: 50)
                        Spacer()
                    }
                    HStack {
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2.5).blur(radius: 50)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2.3).blur(radius: 50)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Circle().fill(Color("BG Accent")).frame(width: geometry.size.width/2.3).blur(radius: 50)
                    }
                    
                }.opacity(0.9)
            }
        }
    }
}

#Preview {
    Background()
}
