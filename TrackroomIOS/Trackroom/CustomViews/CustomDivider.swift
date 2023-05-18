//
//  SwiftUIView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 24/2/22.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: 2, alignment: .center)
            .foregroundColor(Color.gray)
            .padding(.all, 16)
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDivider()
//    }
//}
