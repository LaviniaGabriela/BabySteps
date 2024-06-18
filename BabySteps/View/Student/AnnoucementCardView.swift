//
//  AnnoucementCardView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct AnnouncementCardView: View {
    @State var announcement: Announcement
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(announcement.title)
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 2)
                    
                    Text(announcement.writerName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(announcement.dateEvent)

                
            }
            
            Text(announcement.description)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .padding(.top, 4)
                .padding(.bottom, 4)
            
            HStack {
                Spacer()
                Text("Read more...")
                    .foregroundColor(.accentColor)
            }
            
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
        }
        
    }
}

struct AnnouncementCardView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementCardView(announcement: Announcement(id: "", title: "Oioioi", description: "Essa é uma descrição", photo: "sem foto", dateEvent: "23/09", writerName: "Rapha", type: .events))
    }
}
