//
//  QuizCreatorView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 9/4/22.
//

import SwiftUI
import Alamofire

struct QuizCreatorView: View {
    @Binding var isQuizCreatorActive: Bool
    @State var createQuizSuccess: Bool = false
    @State var noOfQuestionSelection: Int = 1
    
    @State var quizData: CreatorQuizData = CreatorQuizData(title: "Sample Title", description: "Sample Description", start_time: "Start Time", end_time: "End Time", questions: [QuizContent(question: "Question", options: ["A","B","C","D"], correct_option: 0)])
        
    @State var quizCorrectOptionSelection = ["A"]
    
    var quizCorrectOption: [String] = ["A","B","C","D"]
    
    var classPk : Int
    var quizTitle: String
    var quizDescription: String
    var quizStartTime : String
    var quizEndTime: String
    
    var body: some View {
        ZStack(alignment: .top){
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                HStack {
                    Text("Create New Quiz")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.leading, 32)
                    
                    Spacer()
                    
                    Text("Submit Quiz")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding(.top)
                        .padding(.trailing, 32)
                        .onTapGesture {
                            print(quizData)
                            appendCorrectAnswersToQuizData()
                            createNewQuiz()
                        }
                    
                }
                
                //Call CreateQuiz Function
                ForEach(0..<noOfQuestionSelection, id: \.self) { i in
                    VStack {
                        
                        CustomQuizTextField(textFieldInput: $quizData.questions[i].question, textFieldLabel: "Type Question...", iconName: "questionmark.app")
                        CustomQuizTextField(textFieldInput: $quizData.questions[i].options[0], textFieldLabel: "Type First Option...", iconName: "a.square")
                        CustomQuizTextField(textFieldInput: $quizData.questions[i].options[1], textFieldLabel: "Type Second Option...", iconName: "b.square")
                        CustomQuizTextField(textFieldInput: $quizData.questions[i].options[2], textFieldLabel: "Type Third Option...", iconName: "c.square")
                        CustomQuizTextField(textFieldInput: $quizData.questions[i].options[3], textFieldLabel: "Type Forth Option...", iconName: "d.square")
                        
                        HStack {
                            Text("Correct Answer")
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            
                            Picker(selection: $quizCorrectOptionSelection[i], content: {
                                ForEach(quizCorrectOption, id: \.self) {result in
                                    Text(String(result))
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                }
                            }, label: {
                                HStack {
                                    Text(String(quizCorrectOptionSelection[i]))
                                }
                            })
                            .frame(width: 75, height: 30)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 32)
                            .background(Color("GreyColor"))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        
                        
                        CustomDivider()
                        
                    }
                }
                
                Text("Add Question")
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.top, 8)
                    .onTapGesture {
                        initQuizArray()
                    }
                
                
            }
            .padding(.top, 16)
            .alert(isPresented: $createQuizSuccess) {
                Alert(title: Text("Create New Post"), message: Text("New post has been sucessfully created."), dismissButton: .default(Text("OK"), action: {
                    isQuizCreatorActive.toggle()
                }))
            }
        }
        .navigationTitle(quizTitle)
    }
    func initQuizArray() {
        noOfQuestionSelection += 1
        quizCorrectOptionSelection.append("A")
        quizData.questions.append(QuizContent(question: "Question", options: ["A","B","C","D"], correct_option: 1))
    }
    
    func appendCorrectAnswersToQuizData() {
        for i in 0...noOfQuestionSelection - 1 {
            print("Append Correct Answers to Quiz i : \(i)")
            
            if(quizCorrectOptionSelection[i] == "A") {
                print("Append Correct Answers to Quiz First If Local Array: \(quizCorrectOptionSelection[i])")
                quizData.questions[i].correct_option = 1
                print("Append Correct Answers to Quiz First If Quiz Data: \(quizData.questions[i].correct_option)")
            }
            else if(quizCorrectOptionSelection[i] == "B") {
                print("Append Correct Answers to Quiz First If Local Array: \(quizCorrectOptionSelection[i])")
                quizData.questions[i].correct_option = 2
                print("Append Correct Answers to Quiz First If Quiz Data: \(quizData.questions[i].correct_option)")
            }
            else if(quizCorrectOptionSelection[i] == "C") {
                print("Append Correct Answers to Quiz First If Local Array: \(quizCorrectOptionSelection[i])")
                quizData.questions[i].correct_option = 3
                print("Append Correct Answers to Quiz First If Quiz Data: \(quizData.questions[i].correct_option)")
            }
            else if(quizCorrectOptionSelection[i] == "D") {
                print("Append Correct Answers to Quiz First If Local Array: \(quizCorrectOptionSelection[i])")
                quizData.questions[i].correct_option = 4
                print("Append Correct Answers to Quiz First If Quiz Data: \(quizData.questions[i].correct_option)")
            }
        }
    }
    
    func createNewQuiz() {
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let CREATE_NEW_QUIZ = "http://20.212.216.183/api/classroom/\(classPk)/timeline/create-quiz/"
        
        quizData.title = self.quizTitle
        quizData.description = self.quizDescription
        quizData.start_time = self.quizStartTime
        quizData.end_time = self.quizEndTime
        //appendCorrectAnswersToQuizData()
        
        AF.request(CREATE_NEW_QUIZ,
                   method: .post,
                   parameters: quizData,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
            
            let status = response.response?.statusCode
            print("Create New Quiz Status : \(status)")
            
            if (status == 200) {
                createQuizSuccess.toggle()
            }
        }
    }
}
//
//struct QuizCreatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizCreatorView(classPk: 3, quizTitle: "Sample Quiz", quizDescription: "This is a sample quiz", quizStartTime: "20-04-2022 00:00", quizEndTIme: "20-04-2022 00:30")
//    }
//}
