//
//  ContentView.swift
//  CarouselView-Swift
//
//  Created by 王一丁 on 2020/4/25.
//  Copyright © 2020 yidingw. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var data = ["SwiftUI", "UIKit"]
    var body: some View {
        NavigationView {
            List(0..<data.count) { item in
                if item == 0 {
                    NavigationLink(destination: CarouselSwiftUIView()) {
                        Text(self.data[item])
                    }
                } else {
                    NavigationLink(destination: ViewControllerPreview()) {
                        Text(self.data[item])
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("CarouselView"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
