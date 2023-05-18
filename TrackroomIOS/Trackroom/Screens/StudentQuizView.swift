//
//  QuizViewew.swift
//  Trackroom
//
//  Created by Rifatul Islam on 9/4/22.
//

import SwiftUI
import Alamofire

struct StudentQuizView: View {
    @State var submitQuizData: SubmitQuizData = SubmitQuizData(answers: [])
    @State var quizAnswers: [QuizAnswers] = []
    
    @State var answers = [QuizAnswers]()
    @State var studentQuizData: [StudentQuizData] = []
    @State var quizCorrectOptionSelection: [String] = []
    
    @State var quizSubmissionSuccess: Bool = false
    @State var initPickerArray: Bool = false
    @State var viewQuizData: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var quizCorrectOption: [String] = ["A", "B", "C", "D"]
    
    var quizPk: Int
    var quizTitle: String
    
    var body: some View {
        ZStack(alignment: .top){
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                if (viewQuizData) {
                    ForEach(studentQuizData.indices,id:\.self) { i in
                        VStack(alignment: .leading){
                            Text("\(i + 1) . \(studentQuizData[i].question)")
                                .fontWeight(.bold)
                                .padding(.vertical)
                            
                            Text("A. \(studentQuizData[i].options[0])")
                                .padding(.bottom)
                                .font(.callout)
                            
                            Text("B. \(studentQuizData[i].options[1])")
                                .padding(.bottom)
                                .font(.callout)

                            Text("C. \(studentQuizData[i].options[2])")
                                .padding(.bottom)
                                .font(.callout)

                            Text("D. \(studentQuizData[i].options[3])")
                                .padding(.bottom)
                                .font(.callout)

                            HStack {
                                Text("Correct Answer")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Picker(selection: $quizCorrectOptionSelection[i],
                                       content: {
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
                                    .frame(width: 45, height: 30)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 32)
                                    .background(Color("GreyColor"))
                                    .cornerRadius(10)
                            }
                            .padding(.bottom)
                        }
                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 32)
                    }
                    
                    Button{
                        print("Button tapped")
                        submitQuiz()
                    } label: {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("Quiz : \(quizTitle)")
        .onAppear {
            print("Inside Student Quiz View ON APPERAR FUNCTION")
            getQuizData()
        }
        .alert(isPresented: $quizSubmissionSuccess) {
            Alert(title: Text("Successfully Submitted"), message: Text("Your quiz has been sucessfully submitted."), dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    func initPicker() {
        print("Inside Student Quiz View INIT PICKER FUNCTION")
        print("Student Quiz Data Array Length 1: \(studentQuizData.count)")
        for _ in 1...studentQuizData.count {
            print("Student Quiz Data Array Length 2: \(studentQuizData.count)")
            quizCorrectOptionSelection.append("A")
        }
        print("Quiz correct option selection values : \(quizCorrectOptionSelection)")
        viewQuizData.toggle()
    }
    
    func initQuizDataToSubmit() {
        print("Inside Student Quiz View SUBMMIT QUIZ FUNCTION")
        print("Inside Student Quiz View SUBMMIT QUIZ FUNCTION PICKER ARRAY : \(quizCorrectOptionSelection)")
        for i in 0...studentQuizData.count - 1{
            
            print("Init Quiz Data i : \(i)")
            
            if(quizCorrectOptionSelection[i] == "A") {
                submitQuizData.answers.append(QuizAnswers(pk: studentQuizData[i].pk, selected_option: 1))
            }
            else if(quizCorrectOptionSelection[i] == "B") {
                submitQuizData.answers.append(QuizAnswers(pk: studentQuizData[i].pk, selected_option: 2))
            }
            else if(quizCorrectOptionSelection[i] == "C") {
                submitQuizData.answers.append(QuizAnswers(pk: studentQuizData[i].pk, selected_option: 3))
            }
            else if(quizCorrectOptionSelection[i] == "D") {
                submitQuizData.answers.append(QuizAnswers(pk: studentQuizData[i].pk, selected_option: 4))
            }
            
        }
        print("Inside Student Quiz View FOR OPTIONS : \(submitQuizData)")

    }
    
    func getQuizData() {
        print("Inside Get Quiz Data Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let GET_QUIZ_DATA = "http://20.212.216.183/api/quiz/\(quizPk)/question/"
        
        AF.request(GET_QUIZ_DATA, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if let response = try? JSONDecoder().decode([StudentQuizData].self, from: data) {
                print("Get Quiz Data Success Status Code : \(String(describing: status))")
                studentQuizData = response
                print(studentQuizData)
                initPicker()
                return
            }
            else {
                print("Get Quiz Data Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func submitQuiz() {
        print("Inside Submit Quiz Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let SUBMIT_QUIZ = "http://20.212.216.183/api/quiz/\(quizPk)/submit/"
        
        initQuizDataToSubmit()
        
        AF.request(SUBMIT_QUIZ,
                   method: .post,
                   parameters: submitQuizData,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if status == 200 {
                print("Quiz Submitted Successfully.")
                quizSubmissionSuccess.toggle()
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        StudentQuizView(quizPk: 1, quizTitle: "Test Quiz")
    }
}
