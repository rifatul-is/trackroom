//
//  DetailedPostView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 3/4/22.
//

import SwiftUI
import Alamofire
import PDFKit

import PSPDFKit
import PSPDFKitUI

struct DetailedPostView: View {
    @State var comment: String = ""
    @State var postDetails = PostDetails(file: "", file_type: "")
    @State var studentQuizStatus: StudentQuizStatus = StudentQuizStatus(has_attended: false, grade: "0/0")
    @State var quizDetails: QuizDetails = QuizDetails(pk: 1, title: "Quiz", start_time: "New", end_time: "10 Min", description: "Description Goes Here", date_created: "Today")
    @State var postComments: [PostComments] =  [PostComments(pk: 0, comment: "Posted comments will appeare here.", date_created: "01-02-03", creator: "Rifatul (Ramim)", creator_image: "")]
    @State var userImage: String = ""
    @State var postAuthor: String = ""

    
    var postPk: Int
    var isClassCreator: Bool
    var postTitle: String
    var postDescription: String
    var postDate: String
    var postType: String
    var creatorImage: String
        
    var body: some View {
        ZStack {
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                
                HStack {
                    
                    let creatorImageUrl = "http://20.212.216.183\(creatorImage)"
                    
                    AsyncImage(url: URL(string: creatorImageUrl)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.white
                    }
                    .frame(width: 50, height: 50, alignment: .top)
                    .clipShape(Circle())
                    .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                    .padding(.leading, 16)
                    
                    
//                    Image("LuffyProfilePicture")
//                        .resizable()
//                        .frame(width: 60, height: 50, alignment: .top)
//                        .clipShape(Circle())
//                        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
//                        .padding(.leading, 16)
                                        
                    VStack(alignment: .leading) {
                        Text (postAuthor)
                            .fontWeight(.bold)
                        
                        Text(postDate)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()

                }
                
                CustomDivider()
                
                Text(postDescription)
                    .font(.callout)
                    .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // MARK: Quiz Section
                if (postType == "Quiz") {
                    HStack{
                        Text("Start Time")
                            .font(.callout)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 20, alignment: .leading)
                
                        Text(quizDetails.start_time)
                            .font(.callout)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Text("End Time")
                            .font(.callout)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 20, alignment: .leading)
                
                        Text(quizDetails.end_time)
                            .font(.callout)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)


                    if(isClassCreator) {
                        NavigationLink("View Quiz", destination: CreatorQuizView(quizPk: postPk)).padding()
                    }
                    else {
                        if studentQuizStatus.has_attended {
                            NavigationLink("View Quiz Result", destination: QuizResultView(isCreator: false, quizGrade: studentQuizStatus.grade)).padding()

                        }
                        else {
                            NavigationLink("Attend Quiz", destination: StudentQuizView(quizPk: postPk, quizTitle: quizDetails.title)).padding()
                        }
                    }
                }
                
                // MARK: PDF and Image Handler
                else {
                    if(postDetails.file_type == "PDF") {
                        let document = Document(url: URL(string: postDetails.file)!)
                        //let fileUrl = URL(string: postDetails.file)

                        //PDFDocument(url: fileUrl!)
                        
                        PDFView(document: document)
                            .scrollDirection(.horizontal)
                            .pageTransition(.scrollContinuous)
                            .pageMode(.single)
                            .frame(minWidth: 320, idealWidth: 380, maxWidth: 450, minHeight: 520, idealHeight: 580, maxHeight: 650, alignment: .center)                     
                    }
                    
                    else if(postDetails.file_type == "Image") {
                        AsyncImage(url: URL(string: postDetails.file)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.white
                        }
                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity,alignment: .center)
                        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                    }
                }
                
                // MARK: Class Comments
                if (postType == "Module") {
                    
                    if(postComments.count < 1) {
                        Text("No Comments Yet!")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 30, idealHeight: 35, maxHeight: 40, alignment: .leading)
                            .padding(.horizontal)
                    }
                    else {
                        Text ("Class Comments")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 35, idealHeight: 40, maxHeight: 40, alignment: .leading)
                            .padding(.horizontal)
                        
                        ForEach(postComments, id: \.self) { i in
                            HStack(alignment: .top) {
                                let commenteeImage = "http://20.212.216.183\(i.creator_image)"
                                
                                AsyncImage(url: URL(string: commenteeImage)) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.white
                                }
                                .frame(width: 40, height: 40, alignment: .top)
                                .clipShape(Circle())
                                .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                                .padding(.leading, 16)
                                
//                                Image("LuffyProfilePicture")
//                                    .resizable()
//                                    .frame(width: 50, height: 40, alignment: .top)
//                                    .clipShape(Circle())
//                                    .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
//                                    .padding(.leading, 16)
                                                    
                                VStack(alignment: .leading) {
                                    if i.creator.count > 0 {
                                        let index = i.creator.firstIndex(of: "(")
                                        let name = i.creator.prefix(upTo: index!)
                                        
                                        Text (name)
                                            .fontWeight(.bold)
                                        
                                        Text(i.comment)
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                    }
                                    else {
                                        Text (i.creator)
                                            .fontWeight(.bold)
                                        
                                        Text(i.comment)
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.leading, 4)
                                Spacer()
                            }
                        }
                    }
                    
                    // MARK: Make Comments
                    HStack {
                        AsyncImage(url: URL(string: userImage)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.white
                        }
                        .frame(width: 40, height: 40, alignment: .top)
                        .clipShape(Circle())
                        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                        .padding(.leading, 16)
                        .padding(.trailing, 4)
                        
//                        Image("LuffyProfilePicture")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 50, height: 40, alignment: .top)
//                            .clipShape(Circle())
//                            .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
//                            .padding(.leading, 16)
                        
                        TextField("Comment", text: $comment)
                            .padding(.all, 12)
                            .padding(.horizontal, 40)
                            .background(Color("WhiteGreyColor"))
                            .foregroundColor(Color("BlackWhiteColor"))
                            .frame(width: .infinity,
                                   height: 42,
                                   alignment: .leading)
                            .cornerRadius(32)
                            .shadow(radius: 4)
                            .padding(.trailing, 16)
                            .overlay(
                                HStack{
                                    Image(systemName: "bubble.right")
                                        .padding(.leading, 16)
                                        .foregroundColor(Color("ShadowColor"))
                                    Spacer()
                                }
                            )
                            .onSubmit {
                                createComment()
                            }
                    }
                    .padding(.top)
                }

            }
        }
        .navigationTitle(postTitle)
        .onAppear {
            getData()
        }
    }
    
    func getData() {
        if (postType == "Quiz") {
            getQuizDetails()
            getQuizStatus()
        }
        else {
            getPostDetails()
            getPostComments()
            getUserImage()
            
        }
    }
    
    func getPostDetails() {
        print("Inside Get Post Details Function")

        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]

        let GET_POST_DETAILS = "http://20.212.216.183/api/module/\(postPk)/"

        AF.request(GET_POST_DETAILS, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode

            if let response = try? JSONDecoder().decode(PostDetails.self, from: data) {
                postDetails = response
                print(postDetails)
                return
            }
            else {
                print("Get Post List Creator Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getQuizDetails() {
        print("Inside Get Quiz Details Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let GET_QUIZ_DETAILS = "http://20.212.216.183/api/quiz/\(postPk)"
        
        AF.request(GET_QUIZ_DETAILS, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if let response = try? JSONDecoder().decode(QuizDetails.self, from: data) {
                print("Get Quiz Details Status Code : \(String(describing: status))")
                quizDetails = response
                print(quizDetails)
                return
            }
            else {
                print("Get Quiz Details Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getQuizStatus() {
        print("Inside Get Quiz Status Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let GET_QUIZ_STATUS = "http://20.212.216.183/api/quiz/\(postPk)/quiz-stats/"
        
        AF.request(GET_QUIZ_STATUS, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if let response = try? JSONDecoder().decode(StudentQuizStatus.self, from: data) {
                print("Get Quiz Details Status Code : \(String(describing: status))")
                studentQuizStatus = response
                print("Test Before Student Quiz Status")
                print(studentQuizStatus)
                return
            }
            else {
                print("Get Quiz Status Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getPostComments() {
        print("Inside Get Quiz Status Function")

        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]

        let GET_POST_COMMENTS = "http://20.212.216.183/api/module/\(postPk)/comment/"

        AF.request(GET_POST_COMMENTS, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode

            if let response = try? JSONDecoder().decode([PostComments].self, from: data) {
                postComments = response
                print(postComments)
                return
            }
            else {
                print("Get Post List Creator Fail Status Code : \(String(describing: status))")
                return
            }
        }

    }
    
    func getUserImage() {
        print("Inside Get User Info Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        AF.request(USER_INFO_URL, method: .get, headers: header).responseJSON { response in
            let status = response.response?.statusCode
            guard let data = response.data else { return }
            print("Get User Info Request Data Save")
            if let response = try? JSONDecoder().decode(getUserInfoResponse.self, from: data) {
                print("Success Status Code : \(String(describing: status))")
                userImage = response.profile_image ?? ""
                postAuthor = response.username ?? ""
                return
            }
            else {
                print("Failed Status Code : \(String(describing: status))")
            }
        }
    }
    
    func createComment() {
        let access = UserDefaults.standard.string(forKey: "access")
        
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        let createComment = CreateComment(comment: self.comment)
                
        let CREATE_NEW_COMMENT = "http://20.212.216.183/api/module/\(postPk)/comment/"
        
        AF.request(CREATE_NEW_COMMENT,
                   method: .post,
                   parameters: createComment,
                   encoder: JSONParameterEncoder.default,
                   headers: header).responseJSON { response in
            
            let status = response.response?.statusCode
            print("Status Code : \(status)")
            
            if status == 201 {
                getData()
                comment = ""
                print("Comment submitted successfully")
            }
        }
    }
}

struct DetailedPostView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedPostView(postPk: 4, isClassCreator: true, postTitle: "Title", postDescription: "Description", postDate: "Date", postType: "Module", creatorImage: "")
    }
}
