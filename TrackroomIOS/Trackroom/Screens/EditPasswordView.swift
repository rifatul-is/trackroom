//
//  EditPasswordView.swift
//  Trackroom
//
//  Created by Rifatul Islam on 18/3/22.
//

import SwiftUI
import Alamofire

struct EditPasswordView: View {
    @Binding var showModal: Bool
    @State var profilePicture: String
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var newPassword2: String = ""
    
    
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
                
                if (profilePicture.count > 1) {
                    AsyncImage(url: URL(string: profilePicture)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.white
                    }
                    .frame(width: 160, height: 160, alignment: .top)
                    .clipShape(Circle())
                    .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                }
                
                else {
                    Image("LuffyProfilePicture")
                        .resizable()
                        .frame(width: 160, height: 160, alignment: .top)
                        .clipShape(Circle())
                        .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                }
                
                CustomDivider()
                
                CustomSecureField(secureFieldLabel: "Current Password", secureFieldInput: $currentPassword, iconName: "lock")
                CustomSecureField(secureFieldLabel: "New Password", secureFieldInput: $newPassword, iconName: "lock.fill")
                CustomSecureField(secureFieldLabel: "Re-Type New Password", secureFieldInput: $newPassword2, iconName: "lock.fill")
 
                Text("You need to input your current password and a set of new passwrods to successfully change your password")
                    .padding(.all, 16)
                    .foregroundColor(Color("BlackWhiteColor"))
                    .font(.caption)
                
                Text("Submit")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .padding()
                    .onTapGesture {
                        
                        print("inside on tap gesture")
                        let changePassword = ChangePassword(new_password: newPassword,
                                                            new_password2: newPassword2,
                                                            old_password: currentPassword)
                        
                        let access = UserDefaults.standard.string(forKey: "access")
                        let headers: HTTPHeaders = [.authorization(bearerToken: access!)]
                        
                        AF.request(CHANGE_PASSWORD,
                                   method: .put,
                                   parameters: changePassword,
                                   encoder: JSONParameterEncoder.default,
                                   headers: headers).response { response in
                            
                            let status = response.response?.statusCode
                            
                            print("Change Password Status : \(status)")
                            switch response.result{
                            case .success:
                                showModal.toggle()
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
            }
        }
    }
}

//struct EditPasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPasswordView()
//    }
//}
