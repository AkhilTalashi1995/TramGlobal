//
//  HelperViews.swift
//  TramGlobal
//
//  Created by Akhil on 03/12/23.
//

import SwiftUI


func linear_background_color() -> some View {
    return Group {
        Rectangle()
        LinearGradient(gradient: Gradient(colors: [Color(hex: "375DF5"), .white]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

func linear_background_color1() -> some View {
    return Group {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "375DF5"), .white]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}
