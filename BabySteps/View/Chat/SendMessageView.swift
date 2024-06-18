//
//  SendMessageView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct SendMessageField: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var user: UserManager
    @State private var message = ""
    @State private var isInputActive = true
    @Binding var updateChat: Bool
    let receiverID: String
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Message"), text: $message)
            
            Button {
                if message != "" {
                    let newMessage = Message(id: "",
                                             text: message, sender: user.userID,
                                             receiver: receiverID,
                                             timestamp: Date())
                    
                    Task {
                        do {
                            let documentID = try await firebaseManager.addChatMessage(newMessage)
                            
                            do {
                                try await firebaseManager.addChatMessageToUser(messageID: documentID, userID: user.userID)
                                try await firebaseManager.addChatMessageToUser(messageID: documentID, userID: receiverID)
                                
                                print(user.chatMessages)
                            } catch {
                                print("Error updating document: \(error)")
                            }
                            
                        } catch {
                            print("Error")
                        }
                    }
                }
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.accentColor)
                    .cornerRadius(50)
            }
        }
        .padding(.leading)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background()
        .cornerRadius(32)
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isInputActive = false
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    isInputActive = true
                }
            }
        }
        
    }
}

//struct SendMessageField_Previews: PreviewProvider {
//    static var previews: some View {
//        SendMessageField()
//    }
//}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = {}
    
    var body: some View {
        ZStack (alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("",  text: $text, onEditingChanged: editingChanged, onCommit:  commit)
        }
    }
}
