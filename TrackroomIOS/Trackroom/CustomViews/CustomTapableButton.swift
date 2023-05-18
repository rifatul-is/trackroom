//
//  CustomTapableButton.swift
//  Trackroom
//
//  Created by Rifatul Islam on 24/2/22.
//

import SwiftUI

struct CustomTapableButton: View {
    public var tapableButtonLable: String
    var body: some View {
        Text(tapableButtonLable)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(Color("WhiteGreyColor"))
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 50,
                alignment: .center
            )
            .background(Color("PrimaryColor"))
            .cornerRadius(32)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
            .padding(.top, 8)
    }
}
