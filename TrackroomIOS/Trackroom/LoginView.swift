import SwiftUI
import Foundation
import Alamofire

struct LoginView: View {
    var body: some View {
        ZStack{
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Login In To Your Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.top, 32)
                
                Image("LoginBanner")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 200,
                           idealWidth: 300,
                           maxWidth: 400,
                           minHeight: 200,
                           idealHeight: 300,
                           maxHeight: 400,
                           alignment: .center)
                    .padding()
                
                loginInWithGoogle()
                
                CustomDivider()
                
                loginForm()
            
                registrationPage()
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
struct loginInWithGoogle: View {
    var body: some View {
        HStack{
            Image("GoogleIcon")
                .resizable()
                .frame(width: 23, height: 23, alignment: .leading)
                .padding(.horizontal)
            Spacer()
            
            Text("Login In With Google")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(Color("BlackWhiteColor"))
            Spacer()
        }
        .padding()
        .background(Color("WhiteGreyColor"))
        .frame(width: .infinity, height: 50, alignment: .center)
        .cornerRadius(32)
        .padding(.horizontal, 16)
        .shadow(radius: 3)
    }
}
struct loginForm: View {
    @State var success = false
    @State var email : String = ""
    @State var password : String = ""
    var body: some View {
        
        CustomTextField(textFieldLabel: "Email", textFieldInput: $email, iconName: "envelope.fill")
        CustomSecureField(secureFieldLabel: "Password", secureFieldInput: $password, iconName: "lock.fill")

        NavigationLink(destination: HomeView(), isActive: $success){
            CustomTapableButton(tapableButtonLable: "Login")
                .onTapGesture {
                    login()
                }
        }
    }
    
    func login() {
        print("Inside Login Function")
        let loginRequest = LoginRequest(email: email, password: password)
        AF.request(LOGIN_URL,
                   method: .post,
                   parameters: loginRequest,
                   encoder: JSONParameterEncoder.default).response { response in
            let status = response.response?.statusCode
            print("Login Function Request Sucessfull")
            print("Status Code : \(status)")
            guard let data = response.data else { return }
            if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                let loginResponse = LoginResponse(refresh: response.refresh, access: response.access)
                print("received access  : \(loginResponse.access) ")
                print("received refresh  : \(loginResponse.refresh) ")
                UserDefaults.standard.set(loginResponse.access, forKey: "access")
                UserDefaults.standard.set(loginResponse.refresh, forKey: "refresh")
                success = true
                return
            }
            else {
                print("Failed to Save Data")
                return
            }
        }
    }
}

struct registrationPage: View {
    var body: some View {
        HStack {
            Text("Not A User ?")
                .fontWeight(.bold)
                .foregroundColor(Color("BlackWhiteColor"))

            NavigationLink(destination: RegistrationView()) {
                    Text("Create An Account")
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .frame(alignment: .leading)
                }
        }
        .padding(.all, 8)
    }
}


