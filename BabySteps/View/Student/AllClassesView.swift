//
//  AllClassesView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct AllClassesView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var allClasses: [RoomClass] = []
    @State private var searchText = ""
    @State var showProfileSheet = false
    @State var showNewClassSheet = false
    private var filteredClasses: [RoomClass] {
        if searchText.isEmpty {
            return allClasses
        } else {
            return allClasses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if allClasses.isEmpty {
                    Text("You still have no classes.\nTap the \"+\" button to create one.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding()
                    
                } else {
                    VStack {
                        ForEach(allClasses) { roomClass in
                            Text(roomClass.name)
                            //                                NavigationLink(value: Panel.roomClass(roomClass.id)) {
                            //                                    Label(roomClass.name, systemImage: "rectangle.inset.filled.and.person.filled")
                            //                                }
                        }
                    }
                    .searchable(text: $searchText)
                    
                }
            }
            .navigationTitle("Classes")
            .toolbar {
                ToolbarItem {
                    Button {
                        showNewClassSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showNewClassSheet) {
                        CreateClassView(showSheet: $showNewClassSheet)
                    }

                }
            }
            .task {
                if !userManager.classes.isEmpty {
                    Task.init(operation: {
                        do {
                            allClasses = []
                            for roomClass in userManager.classes {
                                allClasses.append(try await firebaseManager.fetchClass(withID: roomClass))
                            }
                        } catch {
                            print(error)
                        }
                    })
                }
            }
        }
    }
}

struct ProfileIconView: View {
    var body: some View {
        Image("foto-criança")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

struct AllClassesView_Previews: PreviewProvider {
    static var previews: some View {
        AllClassesView()
    }
}
