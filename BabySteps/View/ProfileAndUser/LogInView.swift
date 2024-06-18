//
//  LogInView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var selection = 0
    var selections = ["School", "Parent"]
    @State private var schoolName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var validPassword: Bool?
    @Binding var pageStatus: ProfilePage
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        GeometryReader { geo in
            VStack {

                Text("Log In")
                    .font(.title)
                    .bold()
                    .padding()
                
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .padding(.top)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding(.vertical)
                    
                    Button {
                        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
                            if let error = error {
                                    print("Error signing in: \(error.localizedDescription)")
                                } else {
                                    if let user = authResult?.user {
                                        userManager.userAuthID = user.uid
                                        print(user.uid)
                                        Task {
                                            do {
                                                let fetchedUser = try await firebaseManager.fetchUser(userAuthID: userManager.userAuthID, collection: "SchoolUsers")
                                                
                                                userManager.userName = fetchedUser.userName
                                                userManager.classes = fetchedUser.roomClasses
                                                userManager.announcements = fetchedUser.announcements
                                                userManager.email = fetchedUser.email
                                                userManager.userID = fetchedUser.id
                                                userManager.studentID = fetchedUser.studentID
                                                userManager.studentName = fetchedUser.studentName
                                                userManager.userType = fetchedUser.userType
                                                userManager.userAuthID = fetchedUser.authID
                                                
                                                UserDefaults.standard.set(fetchedUser.authID, forKey: "UserAuthID")
                                                UserDefaults.standard.set(fetchedUser.id, forKey: "UserID")
                                                UserDefaults.standard.set(fetchedUser.userName, forKey: "UserName")
                                                UserDefaults.standard.set(fetchedUser.email, forKey: "UserEmail")
                                                UserDefaults.standard.set(fetchedUser.roomClasses, forKey: "UserClasses")
                                                UserDefaults.standard.set(fetchedUser.studentName, forKey: "StudentName")
                                                UserDefaults.standard.set(fetchedUser.userType, forKey: "UserType")
                                                
                                                
                                                print("\nLogged in successfully.\n")
                                                pageStatus = .profilePage
                                                
                                            } catch {
                                                print("Error fetching user data: \(error)")
                                            }
                                        }
                                        
                                    }
                                }
                        })
                        
                     
                    } label: {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal, 4)
                            .padding()
                            .disabled(validPassword ?? true)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            }
                    }
                    .padding()
                
                Text("Don't have an account?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top)
                Text("Create one")
                    .foregroundColor(.accentColor)
                    .underline()
                    .onTapGesture {
                        withAnimation {
                            pageStatus = .signUpPage
                        }
                    }
                
                Text("If you are a parent, please contact your school to get your user information, including your specific email and password.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding(.bottom, 64)
                
                Spacer()

            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geo.size.width / 2 : 4 * geo.size.width / 5)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? geo.size.width / 4 : geo.size.width / 10)
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? geo.size.height / 10 : geo.size.height / 10)
        }
            
        
    }
}

//struct LogInView_Previews: PreviewProvider {
//
//    @State var loggedIn = false
//
//    static var previews: some View {
//        LogInView(userManager: UserManager(userID: "", userName: "", userType: "", classes: ["HCpdjohJuZy8ZKMuL3Bh", "tbYCsE2OMFnFs47hDZce"]), loggedIn: $loggedIn)
//    }
//}
