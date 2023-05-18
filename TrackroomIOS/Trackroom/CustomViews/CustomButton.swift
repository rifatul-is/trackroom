//
//  CustomButton.swift
//  Trackroom
//
//  Created by Rifatul Islam on 6/3/22.
//

import Foundation
import SwiftUI

struct CustomButtonDark: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.title2)
        .frame(maxWidth: .infinity, maxHeight: 55, alignment: .center)
        .background(Color("PrimaryColor"))
        .foregroundColor(.white)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: 55,
            alignment: .center
        )
        .cornerRadius(32)
        .shadow(radius: 4)
        .padding(.bottom, 8)
      
        //.contentShape(Rectangle())
        //.foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        //.listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
 }
}

struct CustomButtonLight: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.title2)
        .frame(maxWidth: .infinity, maxHeight: 55, alignment: .center)
        .background(Color("SecondaryColor"))
        .foregroundColor(Color("PrimaryColor"))
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: 55,
            alignment: .center
        )
        .cornerRadius(32)
        .shadow(radius: 4)
        .padding(.bottom, 8)
      
        //.contentShape(Rectangle())
        //.foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        //.listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
 }
}
