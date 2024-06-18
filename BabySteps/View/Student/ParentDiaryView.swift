//
//  ParentDiaryView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct ParentDiaryView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var diaryAvailable: Bool = false
    @State var allAnnouncements: [Announcement] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Report")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    MiniReportCardView(diaryAvailable: $diaryAvailable)
                    .padding(.horizontal)
                    
                    if !diaryAvailable {
                        Text("Today's diary still unavailable")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    Text("Recent Announcements")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if allAnnouncements.isEmpty {
                        Text("No Recent Announcements")
                            .foregroundColor(.gray)
                            .padding(.top)
                            .padding(.horizontal)
                    } else {
                        AnnouncementCardView(announcement: allAnnouncements.first!)
                            .padding(.horizontal)
                        
                        if allAnnouncements.count > 1 {
                            AnnouncementCardView(announcement: allAnnouncements[1])
                                .padding(.horizontal)
                        }
                    }
                    
                    
                    Spacer()
                }
            }
            .onAppear {
                Task {
                    diaryAvailable = false
                    do {
                        let fetchedUser = try await firebaseManager.fetchUser(userAuthID: userManager.userAuthID, collection: "SchoolUsers")
                        userManager.announcements = fetchedUser.announcements
                        print(userManager.announcements)
                    } catch {
                        print("Error fetching user data: \(error)")
                    }
                    
                    for announcementID in userManager.announcements {
                        print(announcementID)
                        
                        do {
                            allAnnouncements.append(try await firebaseManager.fetchAnnouncement(withID: announcementID))
                        } catch {
                            print(error)
                        }
                        
                        
                    }
                }
            

            }
            .navigationTitle("Diary")
            .navigationViewStyle(.stack)
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                    .ignoresSafeArea()
            }
            
        }

    }
}

struct ParentDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        ParentDiaryView()
    }
}
