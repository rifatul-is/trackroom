//
//  DetailedClassroomView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 20/3/22.
//

import SwiftUI
import Alamofire

struct DetailedClassroomView: View {
    @State var isCreateNewPostActive: Bool = false
    @State var isInviteStudentsActive: Bool = false
    @State var leaveClassAlertVisible: Bool = false
    @State var ratingsSelection: Int = -1
        
    @State var postList: [PostList] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var classPk: Int
    var isClassroomCreator: Bool
    var className: String
    var classDescription: String
    var classType: String
    var classRating: String
    var classCatagory: String
    var creatorImage: String
    
    var body: some View {
        ZStack{
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    ZStack {
                        Image("ClassIcon\(classPk % 5)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: .infinity, height: 150, alignment: .center)
                            .clipped()
                            .blendMode(.screen)
                            .opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            HStack {
                                if (classRating.contains("No Ratings Yet")) {
                                    Text("No Rating Yet • \(classCatagory)")
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 16)
                                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 20, idealHeight: 24, maxHeight: 30, alignment: .leading)
                                }
                                else {
                                    Text("\(classRating) ☆ • \(classCatagory)")
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 16)
                                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 20, idealHeight: 24, maxHeight: 30, alignment: .leading)
                                }
                                
                                Spacer()
                                
                                if (isClassroomCreator) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(Font.title3.weight(.bold))
                                        .frame(width: 40, height: 30, alignment: .leading)
                                        .foregroundColor(Color("BlackWhiteColor"))
                                        .onTapGesture {
                                            print("On Tab Gesture Leave Class")
                                            isInviteStudentsActive.toggle()
                                        }
                                        .sheet(isPresented: $isInviteStudentsActive) {
                                            InviteStudentView(classPk: classPk)
                                        }
                                }
                                else {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(Font.title3.weight(.bold))
                                        .foregroundColor(Color("BlackWhiteColor"))
                                        .frame(width: 40, height: 30, alignment: .leading)
                                        .onTapGesture {
                                            print("On Tab Gesture Leave Class")
                                            leaveClassAlertVisible = true
                                        }
                                        .alert(isPresented: $leaveClassAlertVisible) {
                                            Alert(title: Text("Leave Class"), message: Text("Are you sure you want to leave this class?"), primaryButton: .destructive(Text("Leave"), action: {
                                                leaveClass()
                                            }), secondaryButton: .cancel())
                                        }
                                }
                            }
                            
                            Text(classDescription)
                                .padding(.leading)
                                .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 40, idealHeight: 50, maxHeight: 50, alignment: .leading)
                        }
                        
                        
                    }
                    .background(Color("ClassroomCardBgColor"))
                    .cornerRadius(10)
                    .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    if (isClassroomCreator) {
                        NavigationLink(destination: CreateNewPostView(classPk: self.classPk, classType: self.classType)) {
                            ZStack {
                                 HStack {
                                     Image("LuffyProfilePicture")
                                         .resizable()
                                         .frame(width: 60, height: 50, alignment: .center)
                                         .clipShape(Circle())
                                         .padding(.leading)
                                     
                                     Spacer()
                                     
                                     Text("Create A New Post!")
                                         .foregroundColor(Color("BlackWhiteColor"))
                                         .font(.callout)
                                         .fontWeight(.bold)
                                         .frame(minWidth: 200, idealWidth: .infinity, maxWidth: .infinity, minHeight: 20, idealHeight: 25, maxHeight: 30, alignment: .leading)
                                 }
                             }
                             .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 80, idealHeight: 100, maxHeight: 120, alignment: .center)
                             .background(Color("LightGreyColor"))
                             .cornerRadius(10)
                             .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 3)
                             .padding(.horizontal)
                        }
                    }
                    else {
                        ZStack {
                            HStack {
                                
                                ForEach(0..<5) { i in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 20, height: 19, alignment: .leading)
                                        .foregroundColor(self.ratingsSelection >= i ? .yellow : .gray)
                                        .onTapGesture {
                                            self.ratingsSelection = i
                                        }
                                }
                                
                                Spacer()
                                
                                Text("Rate")
                                    .fontWeight(.bold)
                                    .frame(width: 45, height: 30)
                                    .foregroundColor(Color("WhiteGreyColor"))
                                    .padding(.horizontal, 32)
                                    .background(Color("SecondaryColor"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 8)
                        }
                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 40, idealHeight: 50, maxHeight: 60, alignment: .center)
                        .background(Color("LightGreyColor"))
                        .cornerRadius(10)
                        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 3)
                        .padding(.horizontal)
                    }
                    
                    ForEach(postList, id: \.self) { result in
                        NavigationLink(destination: DetailedPostView(postPk: result.pk, isClassCreator: self.isClassroomCreator, postTitle: result.title, postDescription: result.description, postDate: result.date_created, postType: result.post_type, creatorImage: self.creatorImage)) {
                            PostCard(postTitle: result.title, dateCreated: result.date_created, postDescription: result.description)
                       }
                    }
                    
                }
            }
            
        }
        .navigationTitle(className)
        .onAppear(perform: getPostList)
    }
    
    func getPostList() {
        print("Inside Get Post List Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        let GET_POST_LIST = "http://20.212.216.183/api/classroom/\(classPk)/timeline/"
        
        AF.request(GET_POST_LIST, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            
            if let response = try? JSONDecoder().decode([PostList].self, from: data) {
                print("Get Post List Creator Success Status Code : \(String(describing: status))")
                debugPrint("Create Classrooom Response Data Decoded")
                postList = response
                print(postList)
                return
            }
            else {
                print("Get Post List Creator Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func leaveClass() {
        let LEAVE_CLASSROOM = "http://20.212.216.183/api/classroom/\(classPk)/leave/"
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        AF.request(LEAVE_CLASSROOM,
                   method: .post,
                   headers: header).response { response in
            let status = response.response?.statusCode
            print("Leave Class Status Code \(String(describing: status))")
            switch response.result{
            case .success:
                print("Classroom has been left sucessfully")
                self.presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }

    
}

//struct DetailedClassroomView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorDetailedClassroomView(classPk: 2, className: "result.title", classRating: "result.ratings", classCatagory: "result.class_category")
//    }
//}
