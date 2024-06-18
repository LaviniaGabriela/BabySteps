//
//  UserManager.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation

class UserManager: ObservableObject {
    @Published var userAuthID: String = (UserDefaults.standard.string(forKey: "UserAuthID") ?? "")
    @Published var userID: String = (UserDefaults.standard.string(forKey: "UserID") ?? "")
    @Published var email: String = (UserDefaults.standard.string(forKey: "UserEmail") ?? "")
    @Published var userName: String = (UserDefaults.standard.string(forKey: "UserName") ?? "")
    @Published var userType: String = (UserDefaults.standard.string(forKey: "UserType") ?? "")
    @Published var classes: [String] = (UserDefaults.standard.array(forKey: "UserClasses") as? [String] ?? [])
    @Published var announcements: [String] = (UserDefaults.standard.array(forKey: "UserAnnouncements") as? [String] ?? [])
    @Published var studentID: String?
    @Published var studentName: String = (UserDefaults.standard.string(forKey: "StudentName") ?? "")
    @Published var chatMessages: [String] = (UserDefaults.standard.array(forKey: "UserChatMessages") as? [String] ?? [])
    @Published var students: [String] = []

}
