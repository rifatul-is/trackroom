//
//  StudentQuizResultView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 18/4/22.
//

import SwiftUI

struct QuizResultView: View {
    var isCreator: Bool
    var quizGrade: String
    
    var body: some View {
        ZStack {
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView{
                if isCreator {
                    Text("Grade :")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                }
                else {
                    Text("Your Grade :")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                }
        
                Text(quizGrade)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
            }
        }
        .navigationTitle("View Quiz Results")
    }
}

struct StudentQuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultView(isCreator: false, quizGrade: "2/10")
    }
}
