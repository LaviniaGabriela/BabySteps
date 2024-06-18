//
//  ProfileView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import FirebaseAuth

enum ProfilePage {
    case profilePage
    case loginPage
    case signUpPage
}

struct ProfileView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var user: UserManager
    @State var loggedIn: Bool = false
    @State var pageStatus: ProfilePage = .loginPage
    @State private var showDeleteAccountAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                
                if pageStatus == .profilePage {
                    Text("Login Information")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("NAME")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            Text(user.userName)
                                .padding(.bottom)
                            
                            if user.userType == "Parent" {
                                Text("STUDENT NAME")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                                Text(user.studentName)
                                    .padding(.bottom)
                            }

                            Text("EMAIL")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            Text(user.email)
                            
                            Text("You are logged in as a \(user.userType). To switch account types log out and connect to another account.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    }
                    .padding(.horizontal)
                    .navigationTitle("Profile")
                    
                    Button {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            user.userAuthID = ""
                            user.userID = ""
                            user.email = ""
                            user.classes = []
                            user.userName = ""
                            pageStatus = .loginPage
                            user.studentID = ""
                            
                            UserDefaults.standard.set("", forKey: "UserAuthID")
                            UserDefaults.standard.set("", forKey: "UserID")
                            UserDefaults.standard.set("", forKey: "UserName")
                            UserDefaults.standard.set("", forKey: "UserEmail")
                            UserDefaults.standard.set("", forKey: "UserClasses")
                            
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print("Error saving Core Data context: \(error.localizedDescription)")
                        }
                        
                    } label: {
                        Text("Log Out")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Text("Account Settings")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Button(role: .destructive) {
                        
                        showDeleteAccountAlert = true
                        
                        
                    } label: {
                        Text("Delete Account")
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .alert(isPresented: $showDeleteAccountAlert) {
                        Alert(title: Text("Delete Account"), message: Text("Are you sure that you want to delete your account?\nAll of your information will be lost."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {deleteUser()}))
                        
                    }
                    
                    
                } else if pageStatus == .loginPage {
                    LogInView(pageStatus: $pageStatus)
                        .navigationTitle("")
                } else {
                    CreateUserView(pageStatus: $pageStatus)
                        .navigationTitle("")
                }
                
            }
        }
        .background {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                startPoint: .top,
                endPoint: .bottom
            )
                .ignoresSafeArea()
        }
        .onAppear{
            if user.userAuthID != "" {
                pageStatus = .profilePage
            }
        }
        
        .navigationViewStyle(.stack)
        
        
        
        
    }
    
    func deleteUser() {
        let userToDelete = Auth.auth().currentUser
        
        userToDelete?.delete { error in
            if let error = error {
                // An error happened.
                
            } else {
                // Account deleted.
                pageStatus = .loginPage
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(pageStatus: .profilePage)
            .environmentObject(UserManager())
    }
}
