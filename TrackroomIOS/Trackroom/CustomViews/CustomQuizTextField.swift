//
//  CustomTextField.swift
//  Trackroom
//
//  Created by Rifatul Islam on 23/2/22.
//

import SwiftUI

struct CustomQuizTextField: View {
    @Binding public var textFieldInput : String
    var textFieldLabel : String
    var iconName: String
    
    
    var body: some View {
        TextField(textFieldLabel, text: $textFieldInput)
            .font(.callout)
            .padding(.all, 8)
            .padding(.horizontal, 45)
            .background(Color("WhiteGreyColor"))
            .foregroundColor(Color("BlackWhiteColor"))
            .frame(width: .infinity,
                   height: 40,
                   alignment: .leading)
            .cornerRadius(32)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
            .overlay(
                HStack{
                    Image(systemName: iconName)
                        .padding(.horizontal, 32)
                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 40, alignment: .leading)
                        .foregroundColor(Color("BlackWhiteColor"))
                }
            )
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField()
//    }
//}
