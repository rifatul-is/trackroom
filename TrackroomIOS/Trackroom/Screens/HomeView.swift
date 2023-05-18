import SwiftUI

struct HomeView: View {
    //@Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color("BgColor")
                .edgesIgnoringSafeArea(.all)
            
            TabView{
                TabClassrooms()
                    .tabItem() {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                TabNotifications()
                    .tabItem() {
                        Image(systemName: "list.bullet.rectangle.fill")
                        Text("Notifications")
                    }
                TabProfile()
                    .tabItem() {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
            .onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            .accentColor(Color("PrimaryColor"))
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}


