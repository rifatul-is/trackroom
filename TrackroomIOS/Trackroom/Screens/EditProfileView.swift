//
//  EditProfileView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 17/3/22.
//

import SwiftUI
import Alamofire

struct EditProfileView: View {
    @Binding var showModal: Bool
    @State var fullName: String
    @State var bio: String
    @State var isShowPhotosActive: Bool = false
    @State var newProfilePicture = UIImage()
    @State var currentProfilePicture : String
    @State var profilePictureChange: Bool = false
    
    @State var defaultProfilePicture = "LuffyProfilePicture"
    
    var body: some View {
        ZStack(alignment: .top){
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Edit Profile Information")
                    .fontWeight(.bold)
                    .padding(.leading)
                    .font(.title3)
                    .frame(minWidth: 350,
                           idealWidth: .infinity,
                           maxWidth: .infinity,
                           minHeight: 30,
                           idealHeight: 40,
                           maxHeight: 50,
                           alignment: .center)
                    .padding(.top, 32)
                
                ZStack {
                    if(currentProfilePicture == "" && defaultProfilePicture == "") {
                        Image(uiImage: self.newProfilePicture)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150, alignment: .top)
                            .clipShape(Circle())
                            //.padding(.bottom)
                            .opacity(0.5)
                    }
                    else {
                        if (currentProfilePicture.count > 0) {
                            AsyncImage(url: URL(string: currentProfilePicture)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.white
                            }
                            .frame(width: 150, height: 150, alignment: .top)
                            .clipShape(Circle())
                            .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                        }
                        else {
                            Image(defaultProfilePicture)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150, alignment: .top)
                                .clipShape(Circle())
                                //.padding(.bottom)
                                .opacity(0.5)
                        }
                        
                    }

                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 32)
                .onTapGesture {
                    isShowPhotosActive.toggle()
                    defaultProfilePicture = ""
                    currentProfilePicture = ""
                    profilePictureChange.toggle()
                }
                .sheet(isPresented: $isShowPhotosActive) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$newProfilePicture)
                }
                
                CustomDivider()
                
                CustomTextField(textFieldLabel: "New Full Name", textFieldInput: $fullName, iconName: "person.fill")
                CustomTextField(textFieldLabel: "New Bio", textFieldInput: $bio, iconName: "bookmark.fill")
                
                Text("If you don not want to change only one you can leave the other text field empty and apply for changes.")
                    .padding(.all, 16)
                    .foregroundColor(Color("BlackWhiteColor"))
                    .font(.caption)
                
                Text("Submit")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .padding()
                    .onTapGesture {
                        getUserInfo()
                    }
            }
        }
    }
    
    func getUserInfo() {
        print("Inside Change User Info Function")
        
        var userInfo = ChangeUserInfo(username: nil, bio: nil, profile_image: nil)
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        
        if ( profilePictureChange ) {
            guard let profileImageData = newProfilePicture.jpegData(compressionQuality: 0.99) else { return }
            
            var profileImageSize: Int = profileImageData.count
            print("size of image in KB: %f ", Double(profileImageSize) / 1000.0)
            
            if(profileImageSize < 1000) {
                uploadProfileInfo(compressQuality: 0.6)
            }
            else if(profileImageSize < 2000) {
                uploadProfileInfo(compressQuality: 0.5)
            }
            else if(profileImageSize < 3000) {
                uploadProfileInfo(compressQuality: 0.3)
            }
            else if(profileImageSize < 4000) {
                uploadProfileInfo(compressQuality: 0.2)
            }
            else if(profileImageSize < 4000) {
                uploadProfileInfo(compressQuality: 0.1)
            }
            else if(profileImageSize < 5000) {
                uploadProfileInfo(compressQuality: 0.08)
            }
            else {
                uploadProfileInfo(compressQuality: 0.05)
            }

        }
        
        else {
            
            let userInfo = ChangeUserInfo(username: fullName, bio: bio, profile_image: nil)
            
            print(userInfo)
            
            AF.request(CHANGE_USER_INFO,
                       method: .put,
                       parameters: userInfo,
                       encoder: JSONParameterEncoder.default,
                       headers: header).response { response in
                
                let status = response.response?.statusCode
                
                print("Change Prof. Info Status : \(status)")
                switch response.result{
                case .success:
                    showModal.toggle()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func uploadProfileInfo(compressQuality : CGFloat) {
        
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        guard let profileImageData = newProfilePicture.jpegData(compressionQuality: compressQuality) else { return }
        
        var profileImageSize: Int = profileImageData.count
        print("size of image in KB after compression: %f ", Double(profileImageSize) / 1000.0)
        
        AF.upload(multipartFormData: { multipart in
            multipart.append(Data(fullName.utf8) ?? Data("".utf8), withName: "username")
            multipart.append(Data(bio.utf8) ?? Data("".utf8), withName: "bio")
            multipart.append(profileImageData, withName: "profile_image", fileName: "newProfileImage.jpg", mimeType: "image/jpeg")
        }, to: CHANGE_USER_INFO, method: .put, headers: header).responseJSON{ response in
            let status = response.response?.statusCode
            
            print("Change Prof. Info Status : \(status)")
            switch response.result{
            case .success:
                showModal.toggle()
            case .failure(let error):
                print(error)
            }
        }
    }
}

