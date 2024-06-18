//
//  ModallyMuralView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct ModallyMuralView: View {
    let announcementModally: Announcement
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text(announcementModally.title)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .fontWeight(.bold)
                
                Text("By \(announcementModally.writerName) in \(announcementModally.dateEvent).")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                
                Spacer()
            
                VStack (spacing: 16){
                    if verticalSizeClass == .regular && horizontalSizeClass == .regular {
                        AsyncImage(url: URL(string: announcementModally.photo)) { image in
                            image
                                .resizable()
                                .frame(height: 320)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize(horizontal: false, vertical: true)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        } placeholder: {
                            Color.gray
                        }
                    }
                    else {
                        AsyncImage(url: URL(string: announcementModally.photo)) { image in
                            image
                                .resizable()
                                .frame(width: 280 * 1.2 , height: 180 * 1.2)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        } placeholder: {
                            Color.gray
                        }
                    }
                
                    
                    Text(announcementModally.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                }
                    
              
                Spacer()
            }
            .padding(30)
            .background(Color.white)
        }
    }
}

//struct AnnouncementImageView: View {
//    let photo: String
//
//    var body: some View {
//        Image(photo)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//    }
//}
