//
//  ContentView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var user: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var studentList: [Student] = []
    
    @State var selectedPage: Panel? = .mural
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State var selectedStudentID: String? = nil
    @State var selectedChatID: String? = nil
    @State var onOnboarding = (UserDefaults.standard.bool(forKey: "Onboarding"))
    @State var appReady = false
    @State var updateChat = false
    
    var body: some View {
        if !onOnboarding {
            OnboardingView(finishedOnboarding: $onOnboarding)
            
        } else if appReady {
            if UIDevice.current.userInterfaceIdiom != .pad { // iPhone
                TabView {
                    if user.userType == "School" {
                        AllClassesView()
                            .tabItem {
                                Label("Classes", systemImage: "newspaper")
                            }
                        
                        MuralView(firebaseManager: firebaseManager)
                            .tabItem {
                                Label("Mural", systemImage: "rectangle.on.rectangle")
                            }
                        
                        ActivitiesView(firebaseManager: firebaseManager)
                            .tabItem {
                                Label("Activities", systemImage: "calendar")
                            }
                        
                        ChatListView(selectedChatID: $selectedChatID)
                        
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }
                    } else {
                        ParentDiaryView()
                            .tabItem {
                                Label("Diary", systemImage: "newspaper")
                            }
                        
                        MuralView(firebaseManager: firebaseManager)
                            .tabItem {
                                Label("Mural", systemImage: "rectangle.on.rectangle")
                            }
                        
                        ActivitiesView(firebaseManager: firebaseManager)
                            .tabItem {
                                Label("Activities", systemImage: "calendar")
                            }
                        
                        ChatView(updateChat: $updateChat, studentID: user.studentID ?? "No student id available")
                            .tabItem {
                                Label("Chat", systemImage: "bubble.left")
                            }
                        
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle.fill")
                            }
                    }
                    
                }
                .task{
                    do {
                        let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                        
                        user.userName = fetchedUser.userName
                        user.announcements = fetchedUser.announcements
                        user.classes = fetchedUser.roomClasses
                        user.studentID = fetchedUser.studentID
                        user.email = fetchedUser.email
                        user.chatMessages = fetchedUser.chatMessages
                        user.userType = fetchedUser.userType
                        user.studentName = fetchedUser.studentName
                        user.userType = fetchedUser.userType
                        user.students = fetchedUser.students
                        user.studentID = fetchedUser.studentID
                        user.userID = fetchedUser.id

                    } catch {
                        print("Error fetching user data: \(error)")
                    }
                }
            } else { // iPad
                if user.userType == "School" {
                    // if its in mural, activities or profile. only two columns
                    if selectedPage == .activities || selectedPage == .mural || selectedPage == .profile  {
                        NavigationSplitView {
                            SideBarView(selectedPage: $selectedPage, firebaseManager: firebaseManager, user: user, columnVisibility: $columnVisibility)
                        } detail: {
                            if let selectedPage {
                                switch selectedPage {
                                case .activities:
                                    ActivitiesView(firebaseManager: firebaseManager)
                                    
                                case .profile:
                                    ProfileView()
                                    
                                default:
                                    MuralView(firebaseManager: firebaseManager)
                                }
                            }
                        }
                        .task {
                            do {
                                let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                                
                                user.userName = fetchedUser.userName
                                user.announcements = fetchedUser.announcements
                                user.classes = fetchedUser.roomClasses
                                user.studentID = fetchedUser.studentID
                                user.email = fetchedUser.email
                                user.chatMessages = fetchedUser.chatMessages
                                user.userType = fetchedUser.userType
                                user.students = fetchedUser.students

                            } catch {
                                print("Error fetching user data: \(error)")
                            }
                        }
                        
                        
                    } else { // if its in a class or chat. three columns
                        NavigationSplitView(columnVisibility: $columnVisibility) {
                            SideBarView(selectedPage: $selectedPage, firebaseManager: firebaseManager, user: user, columnVisibility: $columnVisibility)
                              } content: {
                                  switch selectedPage {
                                  case .roomClass(let id):
                                      StudentListView(firebaseManager: firebaseManager, classID: id, className: "", selectedStudentID: $selectedStudentID)
                                  default:
                                      ChatListView(selectedChatID: $selectedChatID)
                                  }
                                  
                              } detail: {
                                  switch selectedPage {
                                  case .chat:
                                      if selectedChatID != nil {
                                          ChatView(updateChat: $updateChat, studentID: selectedChatID ?? "")
                                      }
                                      
                                  default:
                                      if selectedStudentID != nil {
                                          StudentDiary(firebaseManager: firebaseManager, studentID: selectedStudentID!)
                                      }
                                  }
                                  
                              }
                              .task {
                                  do {
                                      let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                                      
                                      user.userName = fetchedUser.userName
                                      user.announcements = fetchedUser.announcements
                                      user.classes = fetchedUser.roomClasses
                                      user.studentID = fetchedUser.studentID
                                      user.email = fetchedUser.email
                                      user.chatMessages = fetchedUser.chatMessages
                                      user.userType = fetchedUser.userType
                                      user.studentName = fetchedUser.studentName
                                      user.userType = fetchedUser.userType
                                      user.students = fetchedUser.students

                                  } catch {
                                      print("Error fetching user data: \(error)")
                                  }

                              }
                    }
                } else {
                    NavigationSplitView {
                        SideBarView(selectedPage: $selectedPage, firebaseManager: firebaseManager, user: user, columnVisibility: $columnVisibility)
                    } detail: {
                        if let selectedPage {
                            switch selectedPage {
                            case .activities:
                                ActivitiesView(firebaseManager: firebaseManager)
                                
                            case .profile:
                                ProfileView()
                                
                            case .mural:
                                MuralView(firebaseManager: firebaseManager)
                                
                            case .diary:
                                ParentDiaryView()
                                
                            case .chat:
                                ChatView(updateChat: $updateChat, studentID: user.studentID ?? "No student id available")
                                
                            default:
                                ParentDiaryView()
                            }
                        }
                    }
                    
                    .task{
                        do {
                            let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                            
                            user.userName = fetchedUser.userName
                            user.announcements = fetchedUser.announcements
                            user.classes = fetchedUser.roomClasses
                            user.studentID = fetchedUser.studentID
                            user.email = fetchedUser.email
                            user.chatMessages = fetchedUser.chatMessages
                            user.userType = fetchedUser.userType
                            user.studentName = fetchedUser.studentName
                            user.userType = fetchedUser.userType
                            user.students = fetchedUser.students
                            user.studentID = fetchedUser.studentID
                            user.userID = fetchedUser.id

                        } catch {
                            print("Error fetching user data: \(error)")
                        }
                    }
                }
                
            }
        } else {
            ZStack {
                Color("AccentColor")
                Image("Dice")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
            .ignoresSafeArea()
            .task{
                if user.userType != "" {
                    appReady = true
                } else {
                    do {
                        let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                        
                        user.userName = fetchedUser.userName
                        user.announcements = fetchedUser.announcements
                        user.classes = fetchedUser.roomClasses
                        user.studentID = fetchedUser.studentID
                        user.email = fetchedUser.email
                        user.userType = fetchedUser.userType
                        user.studentName = fetchedUser.studentName
                        user.chatMessages = fetchedUser.chatMessages
                        user.studentName = fetchedUser.studentName
                        user.userType = fetchedUser.userType
                        user.userAuthID = fetchedUser.authID
                        user.students = fetchedUser.students

                        
                        withAnimation(.spring()) {
                            appReady = true
                        }
                        
                    } catch {
                        print("Error fetching user data: \(error)")
                        withAnimation(.spring()) {
                            appReady = true
                        }
                    }
                }
                
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
