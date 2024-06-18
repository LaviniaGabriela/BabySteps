//
//  SideBarView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

enum Panel: Hashable {
    /// The value for the ``MuralView``.
    case mural
    /// The value for the ``ActivitiesView``.
    case activities
    /// The value for the ``ChatView``.
    case chat
    /// The value for the ``ProfileView``.
    case profile
    /// The value for the ``RoomClassView``.
    case roomClass(String)
    
    case diary
}

struct SideBarView: View {
    @Binding var selectedPage: Panel?
    @ObservedObject var firebaseManager: FirebaseManager
    @ObservedObject var user: UserManager
    @Binding var columnVisibility: NavigationSplitViewVisibility
    @State var allClasses: [RoomClass] = []
    @State var showNewClassSheet = false
    
    var body: some View {
            VStack {
                List(selection: $selectedPage) {
                    if user.userType == "School" {
                        Label("Mural", systemImage: "rectangle.on.rectangle")
                            .tag(Panel.mural)
                    
                        Label("Activities", systemImage: "calendar")
                            .tag(Panel.activities)
                        
                        Label("Chat", systemImage: "bubble.left")
                            .tag(Panel.chat)
                        
                        Label("Profile", systemImage: "person.circle")
                            .tag(Panel.profile)
                        
                        Section("Your Classes") {
                            ForEach(allClasses) { roomClass in
                                NavigationLink(value: Panel.roomClass(roomClass.id)) {
                                    Label(roomClass.name, systemImage: "rectangle.inset.filled.and.person.filled")
                                }
                                .listItemTint(.secondary)
                            }
                            
                            if allClasses.isEmpty {
                                Text("You currently have no classes")
                                    .foregroundColor(.gray)
                            }
                            
                            Button("Add Class") {
                                showNewClassSheet = true
                            }
                            .foregroundColor(.accentColor)
                            .sheet(isPresented: $showNewClassSheet) {
                                CreateClassView(showSheet: $showNewClassSheet)
                            }
                        }
                    } else {
                        Label("Diary", systemImage: "newspaper")
                            .tag(Panel.diary)
                        
                        Label("Mural", systemImage: "rectangle.on.rectangle")
                            .tag(Panel.mural)
                    
                        Label("Activities", systemImage: "calendar")
                            .tag(Panel.activities)
                        
                        Label("Chat", systemImage: "bubble.left")
                            .tag(Panel.chat)
                        
                        Label("Profile", systemImage: "person.circle")
                            .tag(Panel.profile)
                    }
                    
                }
                .navigationTitle(user.userName == "" ? "Childly" : user.userName)
                .task {
                    if !user.classes.isEmpty {
                        do {
                            allClasses = []
                            for roomClass in user.classes {
                                allClasses.append(try await firebaseManager.fetchClass(withID: roomClass))
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
}

//struct SideBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideBarView()
//            .environmentObject(ModelDataManager())
//            .environmentObject(NavigationManager())
//    }
//}
