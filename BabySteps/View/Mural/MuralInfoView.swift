//
//  MuralInfoView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI


struct MuralInfoView: View {
    
    let announcement: Announcement
    @EnvironmentObject var userManager: UserManager
    @State var announcements: [Announcement] = []
    @State private var isDetailViewPresented = false
    @State private var presentingLandscapeModal = false // Added state
    
    let textLimit = 10
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if userManager.userAuthID == "" {
            ProfileView()
        } else {
            VStack {
                HStack  {
                    VStack (alignment: .leading) {
                        Text("\(announcement.title)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .aspectRatio(contentMode: .fit)
                        
                        Text("\(announcement.writerName)")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        // .frame(maxWidth: .infinity, alignment: .leading)
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Spacer()
                    
                    Text("\(announcement.dateEvent)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .aspectRatio(contentMode: .fit)
                }
                .padding(10)
                
                HStack {
                    VStack (alignment: .leading){
                        Text("\(announcement.description)")
                            .font(.body)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                if !(verticalSizeClass == .compact && horizontalSizeClass == .compact) {
                                    isDetailViewPresented = true
                                    presentingLandscapeModal = true
                                }
                            }) {
                                Text("Read more...")
                                    .foregroundColor(.accentColor)
                                    .font(.body)
                            }
                            .sheet(isPresented: $isDetailViewPresented) {
                                NavigationView {
                                    ModallyMuralView(announcementModally: announcement)
                                        .onChange(of: verticalSizeClass) { newValue in
                                            if presentingLandscapeModal && (newValue == .compact && horizontalSizeClass == .compact) {
                                                isDetailViewPresented = false
                                                presentingLandscapeModal = false
                                            }
                                        }
                                }
                                .ignoresSafeArea()
                            }
                            
                        }
                    }
                    
                    Spacer()
                    
                    if !(verticalSizeClass == .regular && horizontalSizeClass == .compact) {
                        AsyncImage(url: URL(string: announcement.photo)) { image in
                            image
                                .resizable()
                                .frame(width: 260, height: 150)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        } placeholder: {
                            Color.gray
                        }
                    }
                }
                .padding(10)
                
            }
            .background(Color.white)
            .frame(height: 240)
        }
    }
    
    func formatName(_ fullName: String) -> String {
        let screen = UIScreen.main.bounds
        let screenWidth = screen.width
        
        let components = fullName.split(separator: " ")
        let totalLength = components.reduce(0, { $0 + $1.count })
        
        if totalLength <= 20 || screenWidth > 768 { // iPad width
            return fullName
        } else {
            let firstName = components.first!
            let lastNameInitial = components.last!.prefix(1)
            return "\(firstName) \(lastNameInitial)."
        }
    }
    
}
