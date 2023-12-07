//
//  TabView.swift
//  WaterUrineTracker
//
//  Created by Akhil on 01/09/23.
//

import Foundation
import SwiftUI

struct TabsView: View {
    
    var body: some View {
        
        TabView {
            Group {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("My Profile", systemImage: "person.fill")

                }
            }
        }
//        .tint(k_app_tab_icon_color)
//        
//        .onAppear() {
//            UITabBar.appearance().backgroundColor = hexStringToUIColor(hex: "375DF5").withAlphaComponent(0.85)
//            UITabBar.appearance().backgroundImage = UIImage()
//            UITabBar.appearance().unselectedItemTintColor = .white
//        }
//        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
