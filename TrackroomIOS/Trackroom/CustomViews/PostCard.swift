//
//  PostCard.swift
//  Trackroom
//
//  Created by Rifatul Islam on 27/3/22.
//

import SwiftUI

struct PostCard: View {
    var postTitle: String
    var dateCreated: String
    var postDescription: String
    
    var body: some View {
        VStack {
            Text(postTitle)
                .foregroundColor(Color("BlackWhiteColor"))
                .font(.callout)
                .fontWeight(.bold)
                .padding(.horizontal)
                .frame(minWidth: 200, idealWidth: .infinity, maxWidth: .infinity, minHeight: 10, idealHeight: 15, maxHeight: 20, alignment: .leading)
            
            Text(dateCreated)
                .foregroundColor(Color("BlackWhiteColor"))
                .font(.footnote)
                .fontWeight(.bold)
                .padding(.horizontal)
                .frame(minWidth: 200, idealWidth: .infinity, maxWidth: .infinity, minHeight: 10, idealHeight: 15, maxHeight: 20, alignment: .leading)
            
            Text(postDescription)
                .foregroundColor(Color("BlackWhiteColor"))
                .font(.callout)
                .padding(.horizontal)
                .frame(minWidth: 200, idealWidth: .infinity, maxWidth: .infinity, minHeight: 20, idealHeight: 25, maxHeight: 30, alignment: .leading)
        }
        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 120, idealHeight: 150, maxHeight: 200, alignment: .center)
        .background(Color("LightGreyColor"))
        .cornerRadius(10)
        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct PostCard_Previews: PreviewProvider {
    static var previews: some View {
        PostCard(postTitle: "Title", dateCreated: "Date Created", postDescription: "Description")
    }
}
