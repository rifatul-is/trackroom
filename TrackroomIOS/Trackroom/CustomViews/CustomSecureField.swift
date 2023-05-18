//
//  CustomSecureField.swift
//  Trackroom
//
//  Created by Rifatul Islam on 23/2/22.
//

import SwiftUI

struct CustomSecureField: View {
    var secureFieldLabel : String
    @Binding var secureFieldInput : String
    var iconName: String

    var body: some View {
        SecureField(secureFieldLabel, text: $secureFieldInput)
            .padding(.all, 16)
            .padding(.horizontal, 35)
            .background(Color("WhiteGreyColor"))
            .foregroundColor(Color("BlackWhiteColor"))
            .frame(width: .infinity,
                   height: 50,
                   alignment: .leading)
            .cornerRadius(32)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
            .overlay(
                HStack{
                    Image(systemName: iconName)
                        .padding(.horizontal, 32)
                        .frame(minWidth: 290, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .leading)
                        .foregroundColor(Color("BlackWhiteColor"))
                }
            )

    }
}

//struct CustomSecureField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomSecureField()
//    }
//}
