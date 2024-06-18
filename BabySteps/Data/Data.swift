//
//  Data.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation
import SwiftUI

struct Class {
    var id: UUID = UUID()
    var className: String
    var teachers: [UUID]
    var students: [UUID]
    var shift: String
    var activityDiary: [Date: Diary]
}

class ClassList: ObservableObject {
    @Published var classList: [Class]
    
    init(classList: [Class]) {
        self.classList = [
            Class(
                className: "Math 101",
                teachers: [UUID()],
                students: [UUID()],
                shift: "Morning",
                activityDiary: [:]
            )
        ]
    }
}

struct Diary {
    var id: String
    var studentId: String = ""
    var date: String
    
    var water: DiaryReport = .init(satisfaction: 0, observation: "")
    var milk: DiaryReport = .init(satisfaction: 0, observation: "")
    var fruit: DiaryReport = .init(satisfaction: 0, observation: "")
    var lunch: DiaryReport = .init(satisfaction: 0, observation: "")
    var snackTime: DiaryReport = .init(satisfaction: 0, observation: "")
    
    var attendance: Bool = true
    var attendanceObservation: String
    var completed: Bool = false
    
    struct DiaryReport {
        var satisfaction: Int = 0
        var observation: String
        
        init(satisfaction: Int, observation: String) {
            self.satisfaction = satisfaction
            self.observation = observation
        }
    }
    
    enum SatisfactionLevel {
        case all
        case half
        case few
        case didNotAccept
        case atHome
    }
    
    
}

struct Announcement: Identifiable, Hashable {
    var id: String
    var title: String
    var description: String
    var photo: String
    var dateEvent: String
    var writerName: String
    var type: String  // Store the raw value of the enum as a String
    
    enum Types: String {
        case meetings = "meetings"
        case events = "events"
    }
    
    init(id: String, title: String, description: String, photo: String, dateEvent: String, writerName: String, type: Types) {
        self.id = id
        self.title = title
        self.description = description
        self.photo = photo
        self.dateEvent = dateEvent
        self.writerName = writerName
        self.type = type.rawValue  // Store the raw value of the enum as a String
    }
    
//    func getFormattedDate(date: Date) -> String {
//        let calendar = Calendar.current
//        let identifierLocale: String = "en_US"
//
//        print(date)
//
//        if calendar.isDateInToday(date) {
//            return "Today"
//        } else if calendar.isDateInYesterday(date) {
//            return "Yesterday"
//        } else {
//            let dateFormatter = DateFormatter()
//
//            dateFormatter.dateFormat = "MMMM d"
//
//            dateFormatter.locale = Locale(identifier: identifierLocale)
//
//            return dateFormatter.string(from: date)
//        }
//    }

}

struct RoomClass: Identifiable, Hashable, Codable {
    let id: String
    var shift: String
    var name: String
    var students: [String]
}


//class AnnouncementList: ObservableObject {
//    @Published var data: [Announcement] = [
//        Announcement(
//            id: UUID(),
//            title: "Important Meeting Important Meeting Important Meeting Important Meeting Important Meeting Important Meeting Important Meeting",
//            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec massa massa, tincidunt eu scelerisque fringilla, aliquam sit amet erat. Pellentesque neque tortor, ullamcorper a erat ac, consequat lobortis lorem. Nam eu ipsum sit amet dolor mollis egestas. Proin viverra velit lectus, eu posuere sapien faucibus a. Quisque et mollis diam, et pretium nisi. Donec tellus lorem, luctus sed velit quis, euismod tincidunt felis. Nam eu felis gravida, congue felis ut, placerat nulla. Aenean placerat fermentum aliquet. In consequat arcu diam, scelerisque efficitur est tempus a. Quisque dictum dolor nisl, vitae ornare leo lobortis et.",
//            photo: "https://images.unsplash.com/photo-1568535904307-f48b760a39f3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVkJTIwdGV4dHVyZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
//            dateEvent: "24/08/2023",
//            writerName: "Franciscana Magalhães Neto",
//            type: .events
//        ),
//        Announcement(
//            id: UUID(),
//            title: "Important Meeting",
//            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec massa massa, tincidunt eu scelerisque fringilla, aliquam sit amet erat. Pellentesque neque tortor, ullamcorper a erat ac, consequat lobortis lorem. Nam eu ipsum sit amet dolor mollis egestas. Proin viverra velit lectus, eu posuere sapien faucibus a. Quisque et mollis diam, et pretium nisi. Donec tellus lorem, luctus sed velit quis, euismod tincidunt felis. Nam eu felis gravida, congue felis ut, placerat nulla. Aenean placerat fermentum aliquet. In consequat arcu diam, scelerisque efficitur est tempus a. Quisque dictum dolor nisl, vitae ornare leo lobortis et.",
//            photo: "https://static.vecteezy.com/system/resources/thumbnails/021/091/714/small/green-colored-background-green-screen-background-green-colored-chroma-key-background-screen-flat-style-design-free-free-photo.jpg",
//            dateEvent: "22/08/2023",
//            writerName: "Amarilia Marcelino Neto",
//            type: .meetings
//        )
//    ]
//}

struct Child: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var studentPhoto: String
    var checkMark: Bool
    
    init(name: String, studentPhoto: String, checkMark: Bool) {
        self.id = UUID()
        self.name = name
        self.studentPhoto = studentPhoto
        self.checkMark = checkMark
    }
    
    static func getMockedList() -> [Child] {
        [Child(name: "Joe Joe", studentPhoto: "foto-criança", checkMark: false),
         Child(name: "Joana Joana", studentPhoto: "defaultPhoto", checkMark: false),
         Child(name: "Peter Peter", studentPhoto: "defaultPhoto", checkMark: false)]
    }
}

struct ActivityDiary: Identifiable {
    var id: String = ""
    var date: String
    var activityIds: [String]
    var foodMenuIds: [String]
    var classId: String
}

struct FoodMenu: Identifiable {
    
    enum Types: String {
        case lunch = "Lunch"
        case breakfast = "Breakfast"
    }
    
    var id: String = ""
    var title: String
    var items: [String: [String]]
}

struct Activity: Identifiable {
    var id: String = ""
    var title: String
    var description: String
    var image: String
}

struct SchoolUser: Identifiable {
    var id: String = ""
    var authID: String = ""
    var roomClasses: [String]
    var announcements: [String]
    var chatMessages: [String]
    var activities: [String]
    var email: String
    var studentID: String = ""
    var studentName: String = ""
    var userType: String = ""
    var userName: String = ""
    var students: [String]
}
