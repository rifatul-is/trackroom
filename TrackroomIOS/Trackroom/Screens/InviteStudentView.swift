
import SwiftUI
import Alamofire

struct InviteStudentView: View {
    @State var inviteSuccess: Bool = false
    @State var inviteNumberSelection: Int = 1
    @State var inviteEmailAddress: [String] = ["","","","","","","","","",""]
    @State var borderWidth: CGFloat = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var inviteNumber: [Int] = [1,2,3,4,5,6,7,8,9,10]
    
    var classPk: Int
    
    var body: some View {
        ZStack(alignment: .top){
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Invite A Student")
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(minWidth: 350,
                           idealWidth: .infinity,
                           maxWidth: .infinity,
                           minHeight: 30,
                           idealHeight: 40,
                           maxHeight: 50,
                           alignment: .center)
                    .padding(.top, 32)
                
                HStack {
                    Text("Invite Student")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Picker(selection: $inviteNumberSelection,
                           content: {
                        ForEach(0..<11) {result in
                            Text(String(result))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        }
                    }, label: {
                        HStack {
                            Text(String(inviteNumberSelection))
                        }
                    })
                        .frame(width: 75, height: 30)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 32)
                        .background(Color("GreyColor"))
                        .cornerRadius(10)
                        
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                
                
                    ForEach(0..<inviteNumberSelection, id: \.self) { i in
                        
                        CustomTextField(textFieldLabel: "Email", textFieldInput: $inviteEmailAddress[i], iconName: "envelope.fill")
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.red, lineWidth: borderWidth)
                                    .padding(.horizontal)
                            )
                    }
                    
                    Text("Invite")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 32)
                        .foregroundColor(Color("PrimaryColor"))
                        .onTapGesture {
                            
                            inviteStudents()
                        }
                
            }
            .alert(isPresented: $inviteSuccess) {
                Alert(title: Text("Invite Sucessfull"), message: Text("All the students has been invited sucessfully"), dismissButton: .default(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }
    }
    
    func inviteStudents() {
        let INVITE_STUDENT = "http://20.212.216.183/api/classroom/\(classPk)/invite/"
        
        print("Inside Invite Student Function")
        let access = UserDefaults.standard.string(forKey: "access")
        let header: HTTPHeaders = [.authorization(bearerToken: access!)]
        
        var inviteStudent = InviteStudents(subscriber: [])
        
        for i in 0...inviteNumberSelection - 1 {
            inviteStudent.subscriber.append(inviteEmailAddress[i])
        }
        
        print("Invite Request : \(inviteStudent)")
        
        AF.request(INVITE_STUDENT,
                   method: .post,
                   parameters: inviteStudent,
                   encoder: JSONParameterEncoder.default,
                   headers: header).responseJSON { response in

            let status = response.response?.statusCode
            print("Success Status Code : \(String(describing: status))")
            if (status == 202) {
                inviteSuccess.toggle()
            }
        }
    }
}

struct InviteStudentView_Previews: PreviewProvider {
    static var previews: some View {
        InviteStudentView(classPk: 3)
    }
}
