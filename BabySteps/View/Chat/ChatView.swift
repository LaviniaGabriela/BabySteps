//
//  ChatView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var firebaseManager = FirebaseManager()
    @EnvironmentObject var user: UserManager
    @Binding var updateChat: Bool
    let studentID: String
    @State var student: Student? = nil
    @State var chatAvailable = true
    @State var loading = true
    
    
    @State var allMessages: [Message] = []
    
    var body: some View {
        ZStack {
            if colorScheme == .light {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)
            } else {
                Color(.gray)
            }
            
            if loading {
                ProgressView()
            } else {
                VStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(allMessages, id: \.id) { message in
                                MessageBubble(message: message)
                            }
                            .padding(.top, 32)
                        }
                        .onChange(of: firebaseManager.lastMessageId) { id in
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
                    
                    if user.userType == "School" {
                        SendMessageField(updateChat: $updateChat, receiverID: student?.parentID ?? "Error")
                            .background(.regularMaterial)
                    } else {
                        SendMessageField(updateChat: $updateChat, receiverID: student?.schoolID ?? "Error")
                            .background(.regularMaterial)
                    }
                    
                    
                }
            }
            
            
            
            
        }
        .navigationViewStyle(.stack)
        .navigationTitle(student?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            if UIDevice.current.userInterfaceIdiom != .pad {
                updateChat.toggle()
            }
        }
     
        .task(id: updateChat, {
            withAnimation {
                student = nil
                loading = true
            }
            
            // Clear the allMessages array before fetching new messages
            allMessages = []
            
            firebaseManager.fetchStudent(withID: studentID) { fetchedStudent, error in
                if let error = error {
                    chatAvailable = false
                    loading = false
                    print("Error fetching student: \(error)")
                } else if let fetchedStudent = fetchedStudent {
                    student = fetchedStudent
                    loading = false
                }
            }
            
            do {
                let fetchedUser = try await firebaseManager.fetchUser(userAuthID: user.userAuthID, collection: "SchoolUsers")

                user.chatMessages = fetchedUser.chatMessages
                
                if !user.chatMessages.isEmpty {
                    for message in user.chatMessages {
                        let fetchedMessage = try await firebaseManager.fetchChatMessage(withID: message)
                        print("fM Receiver: \(fetchedMessage.receiver)\nuserID: \(user.userID)\nfM sender: \(fetchedMessage.sender)")
                        if fetchedMessage.receiver == user.userID || fetchedMessage.sender == user.userID  {
                            // Check if the message is already in the allMessages array
                            if !allMessages.contains(where: { $0.id == fetchedMessage.id }) {
                                allMessages.append(fetchedMessage)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        })

    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path (in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
