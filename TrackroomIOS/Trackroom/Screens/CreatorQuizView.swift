//
//  CreatorQuizView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 17/4/22.
//

import SwiftUI
import Alamofire

struct CreatorQuizView: View {
    @State var quizResults: [CreatorQuizStatus] = [CreatorQuizStatus(subscriber: "Loading Data (Wait)", has_attended: false, grade: "")]
    var quizPk: Int
    var body: some View {
        ZStack {
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            List(0..<quizResults.count, id: \.self) { item in
                NavigationLink(destination: QuizResultView(isCreator: true, quizGrade: quizResults[item].grade)) {
                        HStack {
                            let index = quizResults[item].subscriber.firstIndex(of: "(")
                            let name = quizResults[item].subscriber.prefix(upTo: index!)
                                //print(firstPart)
                            Text(name)
                                .font(.headline)
                                .frame(width: 200, height: 20, alignment: .leading)
                            if(quizResults[item].has_attended) {
                                Text("Attended")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            else {
                                Text("Not Attended")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
            }
            .padding(.top)
        }
        .navigationTitle("View Quiz Results")
        .onAppear {
            getQuizMarks()
        }
    }
    
    func getQuizMarks()  {
        print("Inside Get Quiz Marks Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let GET_QUIZ_MARKS = "http://20.212.216.183/api/quiz/\(quizPk)/quiz-stats/"
        
        AF.request(GET_QUIZ_MARKS, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if let response = try? JSONDecoder().decode([CreatorQuizStatus].self, from: data) {
                print("Get Quiz Details For Creator Status Code : \(String(describing: status))")
                quizResults = response
                print(quizResults)
                print("Quiz Results Count : \(quizResults.count)")
                return
            }
            else {
                print("Get Quiz Status For Creator Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
}

struct CreatorQuizView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorQuizView(quizPk: 0)
    }
}
