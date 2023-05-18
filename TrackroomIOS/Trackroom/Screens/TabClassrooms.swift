import SwiftUI
import Alamofire

struct TabClassrooms: View {
    @State var recommendationList: [ClassroomList] = []
    @State var createdClassList: [ClassroomList] = []
    @State var privateClassroomList: [ClassroomList] = []
    @State var publicClassroomList: [ClassroomList] = []
    
    @State var isActiveJoinPublicClassroom: Bool = false
    @State var isActiveJoinPrivateClassroom: Bool = false
    @State var isActiveCreateClassroom: Bool = false
    @State var classJoinSuccessfull: Bool = false
        
    var body: some View {
        ZStack {
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            //Main Vertical Scroll View
            ScrollView {
                Text("Recommendations")
                    .fontWeight(.bold)
                    .padding(.leading)
                    .font(.title)
                    .frame(minWidth: 350,
                           idealWidth: .infinity,
                           maxWidth: .infinity,
                           minHeight: 40,
                           idealHeight: 50,
                           maxHeight: 60,
                           alignment: .leading)
                
                //Recommandations Horizontal Scroll View
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        if(privateClassroomList.count > 0) {
                            ForEach(recommendationList, id: \.self) { result in
                                RecommandationCard(classJoinBind: $classJoinSuccessfull, imageName: "ClassIcon\(result.pk % 6)", classPK: result.pk, className: result.title, classCreator: result.creator, classDescription: result.description, classRating: result.ratings, classCatagory: result.class_category)
                            }
                        }
                        else {
                            Text ("No Class Recommendations Avilable Yet!")
                                .foregroundColor(Color("BlackWhiteColor"))
                                .fontWeight(.bold)
                                .font(.caption)
                        }

                    }
                    .onAppear(perform: getRecommendationList)
                }
                .padding()
                
                //Created Class Title Section With Button
                HStack {
                    Text("Created Classes")
                        .fontWeight(.bold)
                        .padding(.leading)
                        .font(.title2)
                    
                    Spacer()
                    
                    CustomAddButton()
                        .padding(.trailing)
                        .sheet(isPresented: $isActiveCreateClassroom){
                            CreateClassroomView(isActive: $isActiveCreateClassroom)
                        } 
                        .onTapGesture {
                            isActiveCreateClassroom.toggle()
                        }
                    
                }
                .frame(minWidth: 350,
                       idealWidth: .infinity,
                       maxWidth: .infinity,
                       minHeight: 40,
                       idealHeight: 50,
                       maxHeight: 60,
                       alignment: .leading)
                
                
                //Created Classroom Horizontal Scroll View
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        if(createdClassList.count > 0) {
                            ForEach(createdClassList, id: \.self) { result in
                                NavigationLink(destination: DetailedClassroomView(classPk: result.pk, isClassroomCreator: true, className: result.title, classDescription: result.description, classType: result.class_type, classRating: result.ratings, classCatagory: result.class_category, creatorImage: result.creator_image)) {
                                    ClassroomCard(classroomTitle: result.title, classroomType: result.class_type, classroomCatagory: result.class_category, classroomCreator: result.creator, imageName: "ClassIcon\(result.pk % 6)")
                               }
                            }
                        }
                        else {
                            Text ("Press the + button to create a class.")
                                .foregroundColor(Color("BlackWhiteColor"))
                                .fontWeight(.bold)
                                .font(.caption)
                        }

                    }
                    .onAppear {
                        getCreatedClassroomList()
                    }
                }
                .padding()
                
                
                //Paid Cources Titile Section With Button
                HStack {
                    Text("Private Courses")
                        .fontWeight(.bold)
                        .padding(.leading)
                        .font(.title2)
                    
                    Spacer()
    
                    CustomAddButton()
                        .padding(.trailing)
                        .sheet(isPresented: $isActiveJoinPrivateClassroom){
                            JoinPrivateClassroomView(isActive: $isActiveJoinPrivateClassroom)
                        }
                        .onTapGesture {
                            isActiveJoinPrivateClassroom.toggle()
                        }
                }
                
                
                //Private Classroom Horizontal Scroll View
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        if(privateClassroomList.count > 0) {
                            ForEach(privateClassroomList, id: \.self) { result in
                                NavigationLink(destination: DetailedClassroomView(classPk: result.pk, isClassroomCreator: false, className: result.title, classDescription: result.description, classType: result.class_type, classRating: result.ratings, classCatagory: result.class_category, creatorImage: result.creator_image)) {
                                    ClassroomCard(classroomTitle: result.title, classroomType: result.class_type, classroomCatagory: result.class_category, classroomCreator: result.creator, imageName: "ClassIcon\(result.pk % 6)")
                                }
                            }
                        }
                        else {
                            Text ("Press the + button to join a private class.")
                                .foregroundColor(Color("BlackWhiteColor"))
                                .fontWeight(.bold)
                                .font(.caption)
                        }
                        
                    }
                    .onAppear {
                        getPrivateClassroomList()
                    }
                }
                .padding()
                
                
                //Free Cources Titile Section With Button
                HStack {
                    Text("Public Courses")
                        .fontWeight(.bold)
                        .padding(.leading)
                        .font(.title2)
                    
                    Spacer()
                    
                    CustomAddButton()
                        .padding(.trailing)
                        .sheet(isPresented: $isActiveJoinPublicClassroom){
                            JoinPublicClassroomView()
                        }
                        .onTapGesture {
                            isActiveJoinPublicClassroom.toggle()
                        }
                    
                }
                
                
                
                //Free Cources Horizontal Scroll View
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        if(publicClassroomList.count > 0) {
                            ForEach(publicClassroomList, id: \.self) { result in
                                NavigationLink(destination: DetailedClassroomView(classPk: result.pk, isClassroomCreator: false, className: result.title, classDescription: result.description, classType: result.class_type, classRating: result.ratings, classCatagory: result.class_category, creatorImage: result.creator_image)) {
                                    
                                    ClassroomCard(classroomTitle: result.title, classroomType: result.class_type, classroomCatagory: result.class_category, classroomCreator: result.creator, imageName: "ClassIcon\(result.pk % 6)")
                                }
                            }
                        }
                        else {
                            Text ("Press the + button to join a public class.")
                                .foregroundColor(Color("BlackWhiteColor"))
                                .fontWeight(.bold)
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .onAppear {
                    getPublicClassroomList()
                }
            }
            .alert(isPresented: $classJoinSuccessfull) {
                Alert(title: Text("Successfull Enrolled"), message: Text("Class had been jonied sucessfully."), dismissButton: .default(Text("OK"), action: {
                        getPublicClassroomList()
                }))
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .padding(.top, 50)
        .ignoresSafeArea()
        .padding(.bottom,1)
    }
    
    func getRecommendationList() {
        print("Inside Get Recommended Classroom List Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        AF.request(RECOMMENDATION_LIST, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            if let response = try? JSONDecoder().decode([ClassroomList].self, from: data) {
                print("Get Created Class List Success Status Code : \(String(describing: status))")
                recommendationList = response
                print(recommendationList)
                return
            }
            else {
                print("Created Class List Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    func getCreatedClassroomList() {
        print("Inside Create Classroom List Function")
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        AF.request(CREATED_CLASSROOM_LIST, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            if let response = try? JSONDecoder().decode([ClassroomList].self, from: data) {
                print("Get Created Class List Success Status Code : \(String(describing: status))")
                createdClassList = response
                print(createdClassList)
                return
            }
            else {
                print("Created Class List Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getPrivateClassroomList() {
        print("Inside Private Classroom List Function")
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        AF.request(PRIVATE_CLASSROOM_LIST, method: .get, headers: headers).responseJSON { response in
            guard let data = response.data else { return }
            let status = response.response?.statusCode
            if let response = try? JSONDecoder().decode([ClassroomList].self, from: data) {
                print("Get Private Class List Success Status Code : \(String(describing: status))")
                privateClassroomList = response
                print(privateClassroomList)
                return
            }
            else {
                print("Get Private Class List Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getPublicClassroomList() {
        print("Inside Public ClassroomList Function")
        let access = UserDefaults.standard.string(forKey: "access")
        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
        AF.request(PUBLIC_CLASSROOM_LIST, method: .get, headers: headers).responseJSON { response in
            let status = response.response?.statusCode
            guard let data = response.data else { return }
            if let response = try? JSONDecoder().decode([ClassroomList].self, from: data) {
                print("Public Class Response Success Status Code : \(String(describing: status))")
                publicClassroomList = response
                print(publicClassroomList)
                return
            }
            else {
                print("Public Class List Fail Status Code : \(String(describing: status))")
                return
            }
        }
    }
    
    func getUserName() {
        print("Inside Get User Info Function")
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        AF.request(USER_INFO_URL, method: .get, headers: header).responseJSON { response in
            let status = response.response?.statusCode
            guard let data = response.data else { return }
            print("Get User Info Request Data Save")
            if let response = try? JSONDecoder().decode(getUserInfoResponse.self, from: data) {
                print("Success Status Code : \(String(describing: status))")
                //userImage = response.profile_image ?? ""
                return
            }
            else {
                print("Failed Status Code : \(String(describing: status))")
            }
        }
    }
}

struct TabHome_Previews: PreviewProvider {
    static var previews: some View {
        TabClassrooms()
    }
}

struct RecommandationCard: View {
    @Binding var classJoinBind: Bool
    var imageName : String
    var classPK : Int
    var className : String
    var classCreator: String
    var classDescription: String
    var classRating: String
    var classCatagory: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .frame(width: .infinity,
                       height: 200,
                       alignment: .center)
                .blendMode(.screen)
                .opacity(0.5)

            VStack(alignment: .leading, spacing: 16){

                HStack {
                    Text(className)
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("PrimaryColor"))
                        .onTapGesture {
                            joinRecommendedClass()
                        }
                }

                Text("\(classRating) ☆ • \(classCatagory)")
                    .font(.callout)
                    .fontWeight(.bold)

                Text(classDescription)
                    .frame(width: .infinity, height: 30, alignment: .leading)

                Text(classCreator)
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .padding(.all, 16)
        .frame(minWidth: 300,
               idealWidth: 320,
               maxWidth: 330,
               minHeight: 170,
               idealHeight: 180,
               maxHeight: 200,
               alignment: .leading)
        .background(Color("ClassroomCardBgColor"))
        .cornerRadius(10)
        .shadow(radius: 3)
        .foregroundColor(Color("BlackWhiteColor"))
    }
    
    func joinRecommendedClass() {
        let JOIN_PUBLIC_CLASSROOM = "http://20.212.216.183/api/classroom/\(classPK)/join/"
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        AF.request(JOIN_PUBLIC_CLASSROOM,
                   method: .post,
                   headers: header).response { response in
            let status = response.response?.statusCode
            print("Status Code Join Public Classroom : \(String(describing: status))")
            switch response.result{
            case .success:
                if (status == 201) {
                    print("Classroom has been joined sucessfully")
                    classJoinBind = true
                    print(classJoinBind)
                }
                
            case .failure(let error):
                print("Response Error Join Public Classroom")
                print(error)
            }
        }
    }
}
