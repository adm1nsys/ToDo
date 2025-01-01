//
//  GitLink.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct GitLink: View {
    var body: some View {
        Link(destination: URL(string: "https://github.com/adm1nsys")!) {
            VStack() {
                HStack {
                    Image("Git")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 50.0, height: 50.0)
                    Text("GitHub")
                        .font(.system(size: 30, weight: .bold, design: .default))
                }
                Text("github.com/adm1nsys")
                    .font(.body)
            }
        }
    }
}

#Preview {
    GitLink()
}
