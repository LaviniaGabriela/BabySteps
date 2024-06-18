//
//  MessageBubble.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct MessageBubble: View {
    @EnvironmentObject var userManager: UserManager
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        
        // MARK: BUG - Solve probems with session and sending messagens. In resume, when a person with false on received var send a message, he messages goes in gray color.
        
        VStack(alignment: message.receiver == userManager.userID ? .leading : .trailing, spacing: 4) {
            Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(message.receiver == userManager.userID ? .leading : .trailing, 0)
            
            HStack {
                Text(message.text)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(message.receiver == userManager.userID ? Color.gray.opacity(0.2) : Color.accentColor.opacity(0.3))
                    .cornerRadius(20)
            }
            .frame(maxWidth: 300, alignment: message.receiver == userManager.userID ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            
            
            //            if showTime {
            //                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
            //                    .font(.caption2)
            //                    .foregroundColor(.gray)
            //                    .padding(message.received ? .leading : .trailing, 25)
            //
            //            }
        }
        .frame(maxWidth: .infinity, alignment: message.receiver == userManager.userID ? .leading : .trailing)
        .padding(message.receiver == userManager.userID ? .leading : .trailing)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        
    }
}
//
//struct MessageBubble_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageBubble(message:
//                        Message(id: "12335",
//                                text: "First message of the app",
//                                received: true,
//                                timestamp: Date()))
//    }
//}
