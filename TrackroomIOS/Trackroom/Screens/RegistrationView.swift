import SwiftUI

import SwiftUI
import Alamofire

struct Login: Encodable {
    let username: String
    let email: String
    let password: String
    let password2: String
}

struct RegistrationView: View {
    var body: some View {
        ZStack {
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Create Account")
                   .font(.title)
                   .fontWeight(.bold)
                   .foregroundColor(Color("PrimaryColor"))
                   .padding(.top,32)
               
                Image("RegistrationBanner")
                   .resizable()
                   .scaledToFit()
                   .frame(minWidth: 200,
                          idealWidth: 300,
                          maxWidth: 400,
                          minHeight: 200,
                          idealHeight: 300,
                          maxHeight: 400,
                          alignment: .center)
                   .padding(.all, 32)
                
                CustomDivider()
                
                registrationForm()
                
                loginPage()
            }
        }
        .navigationBarHidden(true)

    }
}

struct registrationForm: View {
    @State var success = false
    @State private var fullName : String = ""
    @State  private var email : String = ""
    @State private var password : String = ""
    @State private var password2 : String = ""
    
    var body: some View {
        
        CustomTextField(textFieldLabel: "Full Name", textFieldInput: $fullName, iconName: "person.fill")
        CustomTextField(textFieldLabel: "E-mail", textFieldInput: $email, iconName: "envelope.fill")
        CustomSecureField(secureFieldLabel: "Password", secureFieldInput: $password, iconName: "lock")
        CustomSecureField(secureFieldLabel: "Re-Type Password", secureFieldInput: $password2, iconName: "lock.fill")
        
        NavigationLink(destination: LoginView(), isActive: $success){
            CustomTapableButton(tapableButtonLable: "Register")
                .onTapGesture {
                    registerUser()
                }
        }
    }
    
    func registerUser() {
        print("Inside Register Function")
        let registerRequest = RegisterRequest(username: fullName,
                                    email: email,
                                    password: password,
                                    password2: password2)
        
        AF.request(REGISTER_URL,
                   method: .post,
                   parameters: registerRequest,
                   encoder: JSONParameterEncoder.default).response { response in
            let status = response.response?.statusCode
            print("Register Respoonse : \(String(describing: status))")
            print("Username : \(fullName)")
            print("Email : \(email)")
            print("Password : \(password)")
    
            switch response.result{
                case .success:
                    success = true
                case .failure(let error):
                    print(error)
            }
        }
    }
}
//
//struct Register: View {
//    var body: some View {
//        Text("Create Account")
//            .font(.title2)
//            .fontWeight(.bold)
//            .foregroundColor(.white)
//            .frame(
//                minWidth: 0,
//                maxWidth: .infinity,
//                minHeight: 0,
//                maxHeight: 50,
//                alignment: .center
//            )
//            .background(Color("PrimaryColor"))
//            .cornerRadius(32)
//            .shadow(radius: 3)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//
//    }
//}

struct loginPage: View {
    var body: some View {
        HStack {
            Text("Already A User?")
                .fontWeight(.bold)
            NavigationLink(destination: LoginView()) {
                Text("Login To Account")
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
            }

        }
        .padding()
    }
}

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
