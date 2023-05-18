//
//  ClassCard.swift
//  Trackroom
//
//  Created by Rifatul Islam on 27/3/22.
//

import SwiftUI

struct ClassroomCard: View {
    var classroomTitle: String
    var classroomType: String
    var classroomCatagory: String
    var classroomCreator: String
    var imageName : String
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .frame(width: .infinity,
                       height: 210,
                       alignment: .center)
                .blendMode(.screen)
                .opacity(0.5)
            
            VStack(alignment: .leading, spacing: 8){
                Text(classroomTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(classroomType) • \(classroomCatagory)")
                    .frame(width: 250, height: 30, alignment: .leading)
                
                Text(classroomCreator)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.leading)
        }
        .frame(minWidth: 260,
               idealWidth: 280,
               maxWidth: 300,
               minHeight: 120,
               idealHeight: 140,
               maxHeight: 160,
               alignment: .leading)
        .background(Color("ClassroomCardBgColor"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .foregroundColor(Color("BlackWhiteColor"))

    }
    
}

//struct ClassCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassroomCard()
//    }
//}
