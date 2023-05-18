//
//  CreatorDetailedPostView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 27/3/22.
//

import SwiftUI
import Alamofire

struct CreateNewPostView: View {
    @State var postTitle: String = ""
    @State var postDescription: String = ""
    @State var postTypeSelection: String = "Text"
    @State var uploadImage: Bool = false
    @State var uploadDoc: Bool = false
    @State var uploadText: Bool = false
    @State var createNewQuiz: Bool = false
    
    @State var createPostSuccess: Bool = false
    
    @State var titleCheck: CGFloat = 0
    @State var descriptionCheck: CGFloat = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var privatePostType: [String] = ["Text" , "Document", "Image", "Quiz"]
    var publicPostType: [String] = ["Text" , "Document", "Image"]
    
    var classPk: Int
    var classType: String

    
    var body: some View {
        ZStack(alignment: .top){
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                CustomDivider()
                
                CustomTextField(textFieldLabel: "Post Title", textFieldInput: $postTitle, iconName: "character.bubble")
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.red, lineWidth: titleCheck)
                            .padding(.horizontal)
                    )
                CustomTextField(textFieldLabel: "Post Description", textFieldInput: $postDescription, iconName: "text.bubble")
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.red, lineWidth: descriptionCheck)
                            .padding(.horizontal)
                    )
                HStack {
                    Text("Post Type")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if(classType == "Private") {
                        Picker(selection: $postTypeSelection,
                               content: {
                            ForEach(privatePostType, id: \.self) {result in
                                Text(result)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            }
                        }, label: {
                            HStack {
                                Text(postTypeSelection)
                            }
                        })
                            .frame(width: 75, height: 30)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 32)
                            .background(Color("GreyColor"))
                            .cornerRadius(10)
                    }
                    else {
                        Picker(selection: $postTypeSelection,
                               content: {
                            ForEach(publicPostType, id: \.self) {result in
                                Text(result)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            }
                        }, label: {
                            HStack {
                                Text(postTypeSelection)
                            }
                        })
                            .frame(width: 75, height: 30)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 32)
                            .background(Color("GreyColor"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
                
                if postTypeSelection.contains("Text") {
                    Button {
                        if ( postTitle.count > 1 && postDescription.count > 1) {
                            titleCheck = 0
                            descriptionCheck = 0
                            textPost()
                        }
                        else {
                            if (postTitle.count < 1) {
                                descriptionCheck = 0
                                titleCheck = 2
                            }
                            else if ( postDescription.count < 1) {
                                titleCheck = 0
                                descriptionCheck = 2
                            }
                            else {
                                titleCheck = 2
                                descriptionCheck = 2
                            }
                        }
                    } label: {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                    }
                }
                else if postTypeSelection.contains("Document") {
                    Text("Upload Document")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding()
                        .onTapGesture {
                            uploadDoc.toggle()
                        }
                        .fileImporter(isPresented: $uploadDoc, allowedContentTypes: [.pdf]) { result in
                            do {
                                let fileUrl = try result.get()
                                let contents = try Data(contentsOf: fileUrl)

                                print(fileUrl)
                                
                                documentPost(fileData: contents)
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        }
                }
                else if postTypeSelection.contains("Image") {
                    Text("Upload Image")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding()
                        .onTapGesture {
                            uploadImage.toggle()
                        }
                        .fileImporter(isPresented: $uploadImage, allowedContentTypes: [.image]) { result in
                            do {
                                let fileUrl = try result.get()
                                let contents = try Data(contentsOf: fileUrl)

                                print(fileUrl)
                                
                                documentPost(fileData: contents)
                            }
                            catch {
                                print(error.localizedDescription)
                            }                        }
                }
                else if postTypeSelection.contains("Quiz") {
                    Text("Design Quiz")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .padding()
                        .sheet(isPresented: $createNewQuiz) {
                            QuizCreatorView(isQuizCreatorActive: $createNewQuiz, classPk: self.classPk, quizTitle: postTitle, quizDescription: postDescription, quizStartTime: "20-02-2022 00:00", quizEndTime: "20-02-2022 00:30")
                        }
                        .onTapGesture {
                            createNewQuiz.toggle()
                        }
                }
                else {
                    Button {
                        textPost()
                    } label: {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                    }
                }
            }
            .alert(isPresented: $createPostSuccess) {
                Alert(title: Text("Create New Post"), message: Text("New post has been sucessfully created."), dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }
        .navigationTitle("Create New Post")
    }
    
    func textPost() {
        print("Inside Create Post Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let CREATE_NEW_POST = "http://20.212.216.183/api/classroom/\(classPk)/timeline/create-module/"
        
        let createNewPost = CreateNewPost(title: postTitle, description: postDescription, content_material: "")
        print(createNewPost)

        AF.request(CREATE_NEW_POST, method: .post, parameters: createNewPost, headers: header).responseJSON { response in
            let status = response.response?.statusCode
            print("Create Text Post Response : \(status)")
            if (status == 200) {
                //self.presentationMode.wrappedValue.dismiss()
                createPostSuccess.toggle()
            }
        }
        
    }
    
    func documentPost(fileData: Data) {
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let CREATE_NEW_POST = "http://20.212.216.183/api/classroom/\(classPk)/timeline/create-module/"
        
        AF.upload(multipartFormData: { multipart in
            multipart.append(Data(postTitle.utf8), withName: "title")
            multipart.append(Data(postDescription.utf8), withName: "description")
            multipart.append(fileData, withName: "content_material", fileName: "sample.pdf", mimeType: "application/pdf")
            
        }, to: CREATE_NEW_POST, method: .post, headers: header).responseJSON{ response in
            let status = response.response?.statusCode
            print("Create Document Post Response : \(status)")
            if (status == 200) {
                //self.presentationMode.wrappedValue.dismiss()
                createPostSuccess.toggle()
            }
        }
    }
}

//struct CreatorDetailedPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewPostView(classPk: 4, classType: "Public")
//    }
//}
