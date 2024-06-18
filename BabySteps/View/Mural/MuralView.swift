//
//  MuralView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

enum SegmentedPickerOptions: String, CaseIterable {
    case all = "All"
    case meetings = "Meetings"
    case events = "Events"
}

struct MuralView: View {
    // @StateObject var muralData = AnnouncementList()
    @ObservedObject var firebaseManager: FirebaseManager
    @EnvironmentObject var user: UserManager
    @State var allAnnouncement: [Announcement] = []
    @State private var selectionMuralOption: SegmentedPickerOptions = .all
    @State private var shouldFetchData = false
    
    @State private var isAddNewMuralViewPresented = false
    
    var displayedAnnouncements: [Announcement] {
        switch selectionMuralOption {
        case .all:
            return allAnnouncement
        case .meetings:
            return allAnnouncement.filter { $0.type == "meetings" }
        case .events:
            return allAnnouncement.filter { $0.type == "events" }
        }
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: 16) {
                        HStack(alignment: .center) {
                            Picker("mySegment", selection: $selectionMuralOption) {
                                ForEach(SegmentedPickerOptions.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: geometry.size.width * 0.86)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        if user.userID.isEmpty {
                            Text("You must be logged in to view \(selectionMuralOption == .all ? "Meetings or Events" : selectionMuralOption.rawValue).")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            if displayedAnnouncements.isEmpty {
                                VStack (alignment: .center) {
                                    Text("You still have no \(selectionMuralOption == .all ? "Meetings or Events" : selectionMuralOption.rawValue).\nTap the \"+\" button to create one.")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                            } else {
                                ScrollView {
                                    VStack (alignment: .center){
                                        ForEach(displayedAnnouncements) { announcement in
                                            MuralInfoView(announcement: announcement)
                                                .cornerRadius(10)
                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Mural")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAddNewMuralViewPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $isAddNewMuralViewPresented) {
                            AddNewMuralView(
                                firebaseManager: firebaseManager,
                                shouldFetchData: $shouldFetchData // Pass the binding
                            )
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                        user.announcements = fetchedUser.announcements
                        
                        shouldFetchData.toggle()
                    } catch {
                        print("Error fetching user data: \(error)")
                    }
                }
            }
            .task(id: shouldFetchData, {
                do {
                    let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                    user.announcements = fetchedUser.announcements
                    print(user.announcements)
                } catch {
                    print("Error fetching user data: \(error)")
                }
                
                allAnnouncement = []
                print("Announcements: \(user.announcements)\n")
                for announcementID in user.announcements {
                    print(announcementID)
                    do {
                        allAnnouncement.append(try await firebaseManager.fetchAnnouncement(withID: announcementID))
                    } catch {
                        print(error)
                    }
                }
            })
            
        } else {
            NavigationView {
                ZStack { // Wrap the VStack in a ZStack
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    GeometryReader { geometry in
                        VStack(alignment: .center, spacing: 16) {
                            HStack(alignment: .center) {
                                Picker("mySegment", selection: $selectionMuralOption) {
                                    ForEach(SegmentedPickerOptions.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: geometry.size.width * 0.86)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            
                            if user.userID.isEmpty {
                                Text("You must be logged in to view \(selectionMuralOption == .all ? "Meetings or Events" : selectionMuralOption.rawValue).")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                if displayedAnnouncements.isEmpty {
                                    VStack (alignment: .center) {
                                        Text("You still have no \(selectionMuralOption == .all ? "Meetings or Events" : selectionMuralOption.rawValue).\nTap the \"+\" button to create one.")
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                } else {
                                    ScrollView {
                                        VStack (alignment: .center){
                                            ForEach(displayedAnnouncements) { announcement in
                                                MuralInfoView(announcement: announcement)
                                                    .cornerRadius(10)
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }.scrollIndicators(ScrollIndicatorVisibility.hidden)
                    }
                }
                .navigationTitle("Mural")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAddNewMuralViewPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                        .sheet(isPresented: $isAddNewMuralViewPresented) {
                            AddNewMuralView(
                                firebaseManager: firebaseManager,
                                shouldFetchData: $shouldFetchData // Pass the binding
                            )
                        }
                        
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                        user.announcements = fetchedUser.announcements
                        
                        shouldFetchData.toggle()
                    } catch {
                        print("Error fetching user data: \(error)")
                    }
                }
            }
            .task(id: shouldFetchData, {
                do {
                    let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")
                    user.announcements = fetchedUser.announcements
                    print(user.announcements)
                } catch {
                    print("Error fetching user data: \(error)")
                }
                
                allAnnouncement = []
                print("Announcements: \(user.announcements)\n")
                for announcementID in user.announcements {
                    print(announcementID)
                    do {
                        allAnnouncement.append(try await firebaseManager.fetchAnnouncement(withID: announcementID))
                    } catch {
                        print(error)
                    }
                }
            })
        }
    }
}
