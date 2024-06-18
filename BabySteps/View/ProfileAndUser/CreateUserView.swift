//
//  CreateUserView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import FirebaseAuth

struct CreateUserView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var selection = 0
    var selections = ["School", "Parent"]
    @State private var schoolName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var validPassword: Bool?
    @Binding var pageStatus: ProfilePage
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                Text("Sign Up")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("Are you a school or a parent?")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                
                CustomPicker(selection: $selection)
                    .frame(width: 275)
                
                if selection == 0 {
                    TextField("School Name", text: $schoolName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    TextField("School Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .padding()
                        .onSubmit {
                            validPassword = isPasswordValid(password)
                        }
                    
                    Button {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if (error != nil) {
                                print("\nError creating user\n")
                            } else {
                                print("\n\ncreateddd\n\n")
                                if let user = authResult?.user {
                                    let userAuthID = user.uid
                                    userManager.userAuthID = userAuthID
                                    
                                    Task {
                                        do {
                                            let newUserID = try await firebaseManager.addUser(SchoolUser(authID: userAuthID, roomClasses: [], announcements: [], chatMessages: [], activities: [], email: email, userType: "School", students: []))
                                            
                                            userManager.userID = newUserID
                                            
                                        } catch {
                                            print("Error updating document: \(error)")
                                        }
                                    }
                                    Task {
                                        do {
                                            let fetchedUser = try await firebaseManager.fetchUser(userAuthID: userManager.userAuthID, collection: "SchoolUsers")
                                                                        
                                            userManager.userName = fetchedUser.userName
                                            userManager.classes = fetchedUser.roomClasses
                                            userManager.announcements = fetchedUser.announcements
                                            userManager.email = fetchedUser.email
                                            userManager.userID = fetchedUser.id
                                            userManager.studentID = fetchedUser.studentID
                                            userManager.userType = fetchedUser.userType
                                            
                                            UserDefaults.standard.set(user.uid, forKey: "UserAuthID")
                                            UserDefaults.standard.set(fetchedUser.id, forKey: "UserID")
                                            UserDefaults.standard.set(fetchedUser.userName, forKey: "UserName")
                                            UserDefaults.standard.set(fetchedUser.email, forKey: "UserEmail")
                                            UserDefaults.standard.set(fetchedUser.roomClasses, forKey: "UserClasses")
                                            UserDefaults.standard.set(fetchedUser.userType, forKey: "UserType")
                                            
                                            print("\nLogged in successfully.\n")
                                            pageStatus = .profilePage
                                            
                                        } catch {
                                            print("Error fetching user data: \(error)")
                                        }
                                    }
                                    
                                    pageStatus = .profilePage
                                    print("User created successfully with auth ID: \(userManager)")
                                }
                            }
                        }
                    } label: {
                        Text("Create Account")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .disabled(validPassword ?? true)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            }
                    }
                    .padding()
                    
                    
                    Text("Already have an account?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    Text("Log in")
                        .foregroundColor(.accentColor)
                        .underline()
                        .onTapGesture {
                            withAnimation {
                                pageStatus = .loginPage
                            }
                        }
                    
                    Spacer()
                    
                } else {
                    Text("Please contact your school to get your user information, including your specific email and password.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Spacer()
                }

            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? geo.size.width / 2 : 4 * geo.size.width / 5)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? geo.size.width / 4 : geo.size.width / 10)
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? geo.size.height / 10 : geo.size.height / 10)
        }
       
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
//
//struct CreateUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateUserView(pageStatus: <#Binding<ProfilePage>#>)
//    }
//}
