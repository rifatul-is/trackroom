//
//  CustonAddButton.swift
//  Trackroom
//
//  Created by Rifatul Islam on 27/3/22.
//

import SwiftUI

struct CustomAddButton: View {
    var body: some View {
        Image(systemName: "plus.app.fill")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(Color("PrimaryColor"))
    }
}

//struct CustonAddButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CustonAddButton()
//    }
//}
