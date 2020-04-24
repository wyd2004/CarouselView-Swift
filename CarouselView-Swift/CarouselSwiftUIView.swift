//
//  CarouselSwiftUIView.swift
//  CarouselView-Swift
//
//  Created by 王一丁 on 2020/4/25.
//  Copyright © 2020 yidingw. All rights reserved.
//

import SwiftUI

struct CarouselSwiftUIView: View {
    var colors: [Color] =  [.blue, .green, .orange, .red, .gray, .pink, .yellow]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 230) {
                    ForEach(colors, id: \.self) { color in
                        GeometryReader { geometry in
                            Rectangle()
                            .foregroundColor(color)
                            .frame(width: 200, height: 300, alignment: .center)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 210) / -20), axis: (x: 0, y: 1.0, z: 0))
                        }
                    }
                }
        }
    }
}

struct CarouselSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSwiftUIView()
    }
}
