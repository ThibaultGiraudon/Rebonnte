import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        NavigationStack {
            if session.session != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
