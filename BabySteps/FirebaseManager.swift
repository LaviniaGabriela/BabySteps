//
//  FirebaseManager.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var students: [Student] = []
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId = ""
    
//    func listenForChatMessages(completion: @escaping ([Message]) -> Void) {
//        let chatMessagesRef = db.collection("ChatMessages")
//
//        chatMessagesRef.addSnapshotListener { querySnapshot, error in
//            if let error = error {
//                print("Error listening for chat messages: \(error)")
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else { return }
//
//            let chatMessages = documents.compactMap { document -> Message? in
//                do {
//                    return try document.data(as: Message.self)
//                } catch {
//                    print("Error decoding document into Message: \(error)")
//                    return nil
//                }
//            }
//
//            // Sort the messages if needed
//            let sortedMessages = chatMessages.sorted { $0.timestamp < $1.timestamp }
//            completion(sortedMessages)
//        }
//    }
    
    func fetchChatMessage(withID messageID: String) async throws -> Message {
        let messageRef = db.collection("ChatMessages").document(messageID)
        
        let document = try await messageRef.getDocument()
        
        if document.exists {
            let data = document.data()
            
            let id = data?["id"] as? String ?? "Error fetching ID"
            let text = data?["text"] as? String ?? "Error fetching text"
            let sender = data?["sender"] as? String ?? "Error fetching sender"
            let receiver = data?["receiver"] as? String ?? "Error fetching receiver"
            let timestamp = (data?["timestamp"] as? Timestamp)?.dateValue() ?? Date()
            
            return Message(id: id, text: text, sender: sender, receiver: receiver, timestamp: timestamp)
        } else {
            throw ChatMessagesError.noDocument
        }
    }
    
    
    enum ChatMessagesError: Error {
        case noDocument
        case invalidData
        case other(Error)
    }
    
    func addChatMessageToUser(messageID: String, userID: String) async throws {
        let documentRef = db.collection("SchoolUsers").document(userID)

        
        do {
            try await documentRef.updateData([
                "chatMessages": FieldValue.arrayUnion([messageID])
            ])
            print("Document updated successfully.")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func addChatMessage(_ message: Message) async throws -> String {
        let messageData: [String: Any] = [
            "id": message.id,
            "text": message.text,
            "sender": message.sender,
            "receiver": message.receiver,
            "dateText": message.timestamp
        ]
        
        do {
            let documentReference = try await db.collection("ChatMessages").addDocument(data: messageData)
            let documentID = documentReference.documentID
            let messageRef = db.collection("ChatMessages").document(documentID)
            
            try await messageRef.updateData(["id": documentID])
            
            return documentID
        } catch {
            throw error
        }
    }
    
    // MARK: student functions
    func fetchStudents(completion: @escaping ([Student]?, Error?) -> Void) {
        db.collection("Students").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var students: [Student] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? "Error fetching id"
                    let name = data["name"] as? String ?? "Error fetching name"
                    let gender = data["gender"] as? String ?? "Error fetching gender"
                    let address = data["address"] as? String ?? "Error fetching address"
                    let birthDate = data["birthDate"] as? String ?? "Error fetching date"
                    let age = data["age"] as? String ?? "Error fetching age"
                    let mainPhone = data["mainPhone"] as? String ?? "Error fetching main phone"
                    let otherPhone = data["otherPhone"] as? String ?? "Error fetching other phone"
                    let ingressDate = data["ingressDate"] as? String ?? "Error fetching date"
                    let foodRestrictions = data["foodRestrictions"] as? [String] ?? ["Error fetching restrictions"]
                    let allergies = data["allergies"] as? [String] ?? ["Error fetching allergies"]
                    let bloodType = data["bloodType"] as? String ?? "Error fetching blood type"
                    let preferredHospital = data["preferredHospital"] as? String ?? "Error fetching preferred hospital"
                    let missingVaccines = data["missingVaccines"] as? [String] ?? ["Error fetching vaccines"]
                    let studentPhoto = data["studentPhoto"] as? String ?? "Error fetching student photo"
                    let studentClass = data["studentClass"] as? String ?? "Error fetching student photo"
                    let firstResponsible = data["firstResponsible"] as? String ?? "Error fetching parent name"
                    let secondaryResponsible = data["secondaryResponsible"] as? String ?? "Error fetching parent name"
                    let email = data["email"] as? String ?? "Error fetching email"
                    let password = data["password"] as? String ?? "Error fetching password"
                    let parentID = data["parentID"] as? String ?? "Error fetching parent id"
                    let schoolID = data["schoolID"] as? String ?? "Error fetching school id"
                    
                    let student = Student(id: id, name: name, gender: gender, address: address, birthDate: birthDate, age: age, mainPhone: mainPhone, otherPhone: otherPhone, ingressDate: ingressDate, foodRestrictions: foodRestrictions, allergies: allergies, bloodType: bloodType, preferredHospital: preferredHospital, missingVaccines: missingVaccines, studentPhoto: studentPhoto, studentClass: studentClass, firstResponsible: firstResponsible, secondaryResponsible: secondaryResponsible, email: email, password: password, parentID: parentID, schoolID: schoolID)
                    
                    students.append(student)
                    print("\(document.documentID) => \(document.data())")
                }
                
                completion(students, nil)
            }
        }
    }
    
    func fetchAnnouncements(completion: @escaping ([Announcement]?, Error?) -> Void) {
        db.collection("Announcements").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil, err)
            } else {
                var announcements: [Announcement] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? "Error fetching ID"
                    // let id = UUID(uuidString: document.documentID) ?? UUID()
                    let title = data["title"] as? String ?? "Error fetching title"
                    let description = data["description"] as? String ?? "Error fetching description"
                    let photo = data["photo"] as? String ?? "Error fetching photo"
                    
                    let dateEvent = data["dateEvent"] as? String ?? ""
                    //let dateEvent = dateFormatter.date(from: dateString) ?? Date()
                    
                    let writerName = data["writerName"] as? String ?? "Error fetching writerName"
                    
                    let typeRawValue = data["type"] as? String ?? ""
                    let type = Announcement.Types(rawValue: typeRawValue) ?? .meetings
                    
                    let announcement = Announcement(id: id, title: title, description: description, photo: photo, dateEvent: dateEvent, writerName: writerName, type: type)
                    
                    announcements.append(announcement)
                    print("\(document.documentID) => \(document.data())")
                }
                
                completion(announcements, nil)
            }
        }
    }
    
    func fetchStudent(withID studentID: String, completion: @escaping (Student?, Error?) -> Void) {
        let studentRef = db.collection("Students").document(studentID)
        
        studentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting student document: \(error)")
                completion(nil, error)
            } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                let data = documentSnapshot.data()
                
                let id = data?["id"] as? String ?? "Error fetching id"
                let name = data?["name"] as? String ?? "Error fetching name"
                let gender = data?["gender"] as? String ?? "Error fetching gender"
                let address = data?["address"] as? String ?? "Error fetching address"
                let birthDate = data?["birthDate"] as? String ?? "Error fetching date"
                let age = data?["age"] as? String ?? "Error fetching age"
                let mainPhone = data?["mainPhone"] as? String ?? "Error fetching main phone"
                let otherPhone = data?["otherPhone"] as? String ?? "Error fetching other phone"
                let ingressDate = data?["ingressDate"] as? String ?? "Error fetching date"
                let foodRestrictions = data?["foodRestrictions"] as? [String] ?? ["Error fetching restrictions"]
                let allergies = data?["allergies"] as? [String] ?? ["Error fetching allergies"]
                let bloodType = data?["bloodType"] as? String ?? "Error fetching blood type"
                let preferredHospital = data?["preferredHospital"] as? String ?? "Error fetching preferred hospital"
                let missingVaccines = data?["missingVaccines"] as? [String] ?? ["Error fetching vaccines"]
                let studentPhoto = data?["studentPhoto"] as? String ?? "Error fetching student photo"
                let studentClass = data?["studentClass"] as? String ?? "Error fetching student photo"
                let firstResponsible = data?["firstResponsible"] as? String ?? "Error fetching parent name"
                let secondaryResponsible = data?["secondaryResponsible"] as? String ?? "Error fetching parent name"
                let email = data?["email"] as? String ?? "Error fetching email"
                let password = data?["password"] as? String ?? "Error fetching password"
                let parentID = data?["parentID"] as? String ?? "Error fetching parentID"
                let schoolID = data?["schoolID"] as? String ?? "Error fetching schoolID"
                
                let student = Student(id: id, name: name, gender: gender, address: address, birthDate: birthDate, age: age, mainPhone: mainPhone, otherPhone: otherPhone, ingressDate: ingressDate, foodRestrictions: foodRestrictions, allergies: allergies, bloodType: bloodType, preferredHospital: preferredHospital, missingVaccines: missingVaccines, studentPhoto: studentPhoto, studentClass: studentClass, firstResponsible: firstResponsible, secondaryResponsible: secondaryResponsible, email: email, password: password, parentID: parentID, schoolID: schoolID)
                completion(student, nil)
            } else {
                print("Student document not found")
                completion(nil, nil) // or completion(nil, YourCustomError.noDocument)
            }
        }
    }
    
    func addStudent(_ student: Student) async throws -> String {
        let studentData: [String: Any] = [
            "name": student.name,
            "firstResponsible": student.firstResponsible,
            "secondaryResponsible": student.secondaryResponsible,
            "gender": student.gender,
            "address": student.address,
            "birthDate": student.birthDate,
            "age": student.age,
            "mainPhone": student.mainPhone,
            "otherPhone": student.otherPhone,
            "ingressDate": student.ingressDate,
            "foodRestrictions": student.foodRestrictions,
            "allergies": student.allergies,
            "bloodType": student.bloodType,
            "preferredHospital": student.preferredHospital,
            "missingVaccines": student.missingVaccines,
            "studentPhoto": student.studentPhoto,
            "studentClass": student.studentClass,
            "email": student.email,
            "password": student.password
        ]
        
        do {
            let documentReference = try await db.collection("Students").addDocument(data: studentData)
            
            let documentID = documentReference.documentID
            let studentRef = db.collection("Students").document(documentID)
            
            try await studentRef.updateData(["id": documentID])
            return documentID
        } catch {
            throw error
        }
    }
    
    func addStudent(student: Student, completion: @escaping (String?, Error?) -> Void) {
        let studentData: [String: Any] = [
            "name": student.name,
            "firstResponsible": student.firstResponsible,
            "secondaryResponsible": student.secondaryResponsible,
            "gender": student.gender,
            "address": student.address,
            "birthDate": student.birthDate,
            "age": student.age,
            "mainPhone": student.mainPhone,
            "otherPhone": student.otherPhone,
            "ingressDate": student.ingressDate,
            "foodRestrictions": student.foodRestrictions,
            "allergies": student.allergies,
            "bloodType": student.bloodType,
            "preferredHospital": student.preferredHospital,
            "missingVaccines": student.missingVaccines,
            "studentPhoto": student.studentPhoto,
            "studentClass": student.studentClass,
            "email": student.email,
            "password": student.password
        ]
        
        var newDocumentReference: DocumentReference? = nil
        
        // adding student to firestore
        newDocumentReference = db.collection("Students").addDocument(data: studentData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(nil, error)
            } else {
                if let documentID = newDocumentReference?.documentID {
                    // Update the diary's diaryID property in Firestore
                    let studentRef = self.db.collection("Students").document(documentID)
                    studentRef.updateData(["id": documentID]) { error in
                        if let error = error {
                            print("Error updating student id property: \(error)")
                            completion(nil, error)
                        } else {
                            completion(documentID, nil)
                        }
                    }
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    // MARK: diary functions
    func fetchDiary(studentID: String, on date: Date, completion: @escaping (Diary?, Error?) -> Void) {
        let diaryRef = db.collection("Diaries")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let formattedDate = dateFormatter.string(from: date)
        
        let query = diaryRef.whereField("studentID", isEqualTo: studentID)
            .whereField("date", isEqualTo: formattedDate)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting diary entries: \(error)")
                completion(nil, error)
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("\nDiary entry document not found\n")
                    print("tried fetching document with date: \(formattedDate) and studentID: \(studentID)\n")
                    completion(nil, nil)
                    return
                }
                
                let data = document.data()
                
                let date = data["date"] as? String ?? ""
                let waterFetch = data["water"] as? [String: Any] ?? [:]
                let water = Diary.DiaryReport(satisfaction: waterFetch["satisfaction"] as? Int ?? 0, observation: waterFetch["observation"] as? String ?? "")
                
                let milkFetch = data["milk"] as? [String: Any] ?? [:]
                let milk = Diary.DiaryReport(satisfaction: milkFetch["satisfaction"] as? Int ?? 0, observation: milkFetch["observation"] as? String ?? "")
                
                let fruitFetch = data["fruit"] as? [String: Any] ?? [:]
                let fruit = Diary.DiaryReport(satisfaction: fruitFetch["satisfaction"] as? Int ?? 0, observation: fruitFetch["observation"] as? String ?? "")
                
                let lunchFetch = data["lunch"] as? [String: Any] ?? [:]
                let lunch = Diary.DiaryReport(satisfaction: lunchFetch["satisfaction"] as? Int ?? 0, observation: lunchFetch["observation"] as? String ?? "")
                
                let snackTimeFetch = data["snackTime"] as? [String: Any] ?? [:]
                let snackTime = Diary.DiaryReport(satisfaction: snackTimeFetch["satisfaction"] as? Int ?? 0, observation: snackTimeFetch["observation"] as? String ?? "")
                
                let attendance = data["attendance"] as? Bool ?? false
                
                let attendanceObservation = data["attendanceObservation"] as? String ?? "Error fetching observation"
                
                let completed = data["completed"] as? Bool ?? false
                
                let diary = Diary(id: document.documentID, date: date, water: water, milk: milk, fruit: fruit, lunch: lunch, snackTime: snackTime, attendance: attendance, attendanceObservation: attendanceObservation, completed: completed)
                
                completion(diary, nil)
            }
        }
    }
    
    func addDiary(_ diary: Diary) async throws -> String {
        let diaryData: [String: Any] = [
            "id": diary.id,
            "studentID": diary.studentId,
            "date": diary.date,
            "water": [
                "satisfaction": diary.water.satisfaction,
                "observation": diary.water.observation
            ] as [String : Any],
            "milk": [
                "satisfaction": diary.milk.satisfaction,
                "observation": diary.milk.observation
            ] as [String : Any],
            "fruit": [
                "satisfaction": diary.fruit.satisfaction,
                "observation": diary.fruit.observation
            ] as [String : Any],
            "lunchTime": [
                "satisfaction": diary.lunch.satisfaction,
                "observation": diary.lunch.observation
            ] as [String : Any],
            "snackTime": [
                "satisfaction": diary.snackTime.satisfaction,
                "observation": diary.snackTime.observation
            ] as [String : Any],
            "attendance": diary.attendance,
            "attendanceObservation": diary.attendanceObservation,
            "completed": diary.completed
        ]
        
        do {
            // let documentReference = db.collection("Diaries").addDocument(data: diaryData)
            let documentReference = try await db.collection("Diaries").addDocument(data: diaryData)
            let documentID = documentReference.documentID
            let diaryRef = db.collection("Diaries").document(documentID)
            
            try await diaryRef.updateData(["id": documentID])
            
            return documentID
        } catch {
            throw error
        }
    }
    
    func updateDiaryProperty(diaryID: String, propertyName: String, newValue: Any, completion: @escaping (Error?) -> Void) {
        let diaryRef = db.collection("Diaries").document(diaryID)
        
        // Create a dictionary with the property name and its new value
        let updatedData: [String: Any] = [propertyName: newValue]
        
        // Update the diary entry property in Firestore
        diaryRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating diary property: \(error)")
                completion(error)
            } else {
                print("Diary property updated successfully")
                completion(nil)
            }
        }
    }
    
    func updateNestedDiaryProperty(diaryID: String, parentPropertyName: String, childPropertyName: String, newValue: Any, completion: @escaping (Error?) -> Void) {
        let diaryRef = db.collection("Diaries").document(diaryID)
        
        // Create a dictionary with the nested property path and its new value
        let updatedData: [String: Any] = ["\(parentPropertyName).\(childPropertyName)": newValue]
        
        // Update the diary entry property in Firestore
        diaryRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating nested diary property: \(error)")
                completion(error)
            } else {
                print("Nested diary property updated successfully")
                completion(nil)
            }
        }
    }
    
    
    
    func addAnnouncement(_ announcement: Announcement, completion: @escaping (String?, Error?) -> Void) {
        let announcementData: [String: Any] = [
            "title": announcement.title,
            "type": announcement.type,
            "photo": announcement.photo,
            "dateEvent": announcement.dateEvent,
            "writerName": announcement.writerName,
            "description": announcement.description
        ]
        
        var newDocumentReference: DocumentReference? = nil
        
        // Adding announcement to Firestore
        newDocumentReference = db.collection("Announcements").addDocument(data: announcementData) { error in
            if let error = error {
                print("Error adding announcement document: \(error)")
                completion(nil, error)
            } else {
                if let documentID = newDocumentReference?.documentID {
                    // Update the announcement's id property in Firestore
                    let announcementRef = self.db.collection("Announcements").document(documentID)
                    announcementRef.updateData(["id": documentID]) { error in
                        if let error = error {
                            print("Error updating announcement id property: \(error)")
                            completion(nil, error)
                        } else {
                            completion(documentID, nil)
                        }
                    }
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    
    func fetchActicitiesDiary(completion: @escaping ([ActivityDiary]?, Error?) -> Void) {
        db.collection("ActivitiesDiary").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting activities diary entries: \(error)")
                completion(nil, error)
            } else {
                var activities: [ActivityDiary] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let classId = data["classId"] as? String ?? ""
                    
                    let foodMenuIds = data["foodMenuIds"] as? [String] ?? []
                    let activityIds = data["activityIds"] as? [String] ?? []
                    
                    let activityDiary = ActivityDiary(id: id, date: date, activityIds: activityIds, foodMenuIds: foodMenuIds, classId: classId)
                    
                    activities.append(activityDiary)
                }
                
                completion(activities, nil)
            }
        }
    }
    
    func addActivityDiary(_ diary: ActivityDiary) async throws -> String {
        do {
            let diaryData: [String: Any] = [
                "id": "",
                "date": diary.date,
                "activityIds": diary.activityIds,
                "foodMenuIds": diary.foodMenuIds,
                "classId": diary.classId
            ]
            
            let documentReference = try await db.collection("ActivitiesDiary").addDocument(data: diaryData)
            let documentID = documentReference.documentID
            let diaryRef = db.collection("ActivitiesDiary").document(documentID)
            
            try await diaryRef.updateData(["id": documentID])
            
            return documentID
        } catch {
            throw error
        }
    }
    
    func fetchFoodMenus(foodMenuId: String, completion: @escaping (FoodMenu?, Error?) -> Void) {
        let diaryRef = db.collection("FoodMenu")
        
        let query = diaryRef.whereField("id", isEqualTo: foodMenuId)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting food menu entries: \(error)")
                completion(nil, error)
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("Food menus entry document not found")
                    completion(nil, nil)
                    return
                }
                
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let items = data["items"] as? [String : [String]] ?? [:]
                
                let foodMenu = FoodMenu(id: id, title: title, items: items)
                
                completion(foodMenu, nil)
            }
        }
    }
    
    func addFoodMenu(_ foodMenu: FoodMenu) async throws -> String {
        do {
            let foodMenuData: [String: Any] = [
                "id": "",
                "title": foodMenu.title,
                "items": foodMenu.items
            ]
            
            let documentReference = try await db.collection("FoodMenu").addDocument(data: foodMenuData)
            let documentID = documentReference.documentID
            let diaryRef = db.collection("FoodMenu").document(documentID)
            
            try await diaryRef.updateData(["id": documentID])
            
            return documentID
        } catch {
            throw error
        }
    }
    
    func addFoodMenuToDiary(diaryId: String, foodMenuId: String) async throws {
        // Reference to the document you want to update
        let documentRef = db.collection("ActivitiesDiary").document(diaryId)
        do {
            try await documentRef.updateData([
                "foodMenuIds": FieldValue.arrayUnion([foodMenuId])
            ])
            print("Document updated successfully.")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    
    func fetchActivity(id: String, completion: @escaping (Activity?, Error?) -> Void) {
        let diaryRef = db.collection("Activity")
        
        let query = diaryRef.whereField("id", isEqualTo: id)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting acvitivy menu entries: \(error)")
                completion(nil, error)
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("Acvitivy entry document not found")
                    completion(nil, nil)
                    return
                }
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                
                let activity = Activity(id: id, title: title, description: description, image: image)
                
                completion(activity, nil)
            }
        }
    }
    
    // MARK: class functions
    func fetchAllClasses(completion: @escaping ([RoomClass]?, Error?) -> Void) {
        db.collection("Classes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var classes: [RoomClass] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
               
                    let id = data["id"] as? String ?? "Error fetching id"
                    let shift = data["shift"] as? String ?? "Error fetching shift"
                    let name = data["className"] as? String ?? "Error fetching class name"
                    let students = data["students"] as? [String] ?? ["Error fetching students"]
                    
                    let roomClass = RoomClass(id: id, shift: shift, name: name, students: students)
                    
                    classes.append(roomClass)
                    print("\(document.documentID) => \(document.data())")
                }
                
                completion(classes, nil)
            }
        }
    }
    
    func fetchClass(withID classID: String, completion: @escaping (RoomClass?, Error?) -> Void) {
        let studentRef = db.collection("Classes").document(classID)
        
        studentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting class document: \(error)")
                completion(nil, error)
            } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                let data = documentSnapshot.data()
                
                let id = data?["id"] as? String ?? "Error fetching id"
                let shift = data?["shift"] as? String ?? "Error fetching shift"
                let name = data?["className"] as? String ?? "Error fetching class name"
                let students = data?["students"] as? [String] ?? ["Error fetching students"]
                
                let roomClass = RoomClass(id: id, shift: shift, name: name, students: students)
                completion(roomClass, nil)
            } else {
                print("Student document not found")
                completion(nil, nil) // or completion(nil, YourCustomError.noDocument)
            }
        }
    }
    
    func fetchClass(withID classID: String) async throws -> RoomClass {
        if classID != "" {
            let studentRef = db.collection("Classes").document(classID)
            
            let document = try await studentRef.getDocument()
            
            if document.exists {
                let data = document.data()
                
                let id = data?["id"] as? String ?? "Error fetching id"
                let shift = data?["shift"] as? String ?? "Error fetching shift"
                let name = data?["className"] as? String ?? "Error fetching class name"
                let students = data?["students"] as? [String] ?? ["Error fetching students"]
                
                return RoomClass(id: id, shift: shift, name: name, students: students)
            } else {
                throw RoomClassError.noDocument
            }
        } else {
            throw RoomClassError.invalidData
        }
    }
    
    enum RoomClassError: Error {
        case noDocument
        case invalidData
        case other(Error)
    }
    
    func fetchAnnouncement(withID announcementID: String) async throws -> Announcement {
        let studentRef = db.collection("Announcements").document(announcementID)
        
        let document = try await studentRef.getDocument()
        
        if document.exists {
            let data = document.data()
            
            let id = data?["id"] as? String ?? "Error fetching title"
            let title = data?["title"] as? String ?? "Error fetching title"
            let type = data?["type"] as? String ?? "Error fetching type"
            let photo = data?["photo"] as? String ?? "Error fetching class photo"
            let dateEvent = data?["dateEvent"] as? String ?? "Error fetching dateEvent"
            let writerName = data?["writerName"] as? String ?? "Error fetching class writerName"
            let description = data?["description"] as? String ?? "Error fetching description"
            
            
            return Announcement(id: id, title: title, description: description, photo: photo, dateEvent: dateEvent, writerName: writerName, type: Announcement.Types(rawValue: type) ?? .events)
        } else {
            throw AnnouncementsError.noDocument
        }
    }
    
    enum AnnouncementsError: Error {
        case noDocument
        case invalidData
        case other(Error)
    }
    
    func addClass(_ roomClass: RoomClass) async throws -> String {
        let classData: [String: Any] = [
            "id": roomClass.id,
            "email": roomClass.shift,
            "className": roomClass.name,
            "students": roomClass.students,
        ]
        
        do {
            let documentReference = try await db.collection("Classes").addDocument(data: classData)
            // let documentReference = db.collection("Classes").addDocument(data: classData)
            // let documentReference = try await db.collection("Classes").addDocument(data: classData)
            
            let documentID = documentReference.documentID
            let classRef = db.collection("Classes").document(documentID)
            
            try await classRef.updateData(["id": documentID])
            return documentID
        } catch {
            throw error
        }
    }
    
    func addStudentToClass(studentID: String, classID: String) async throws {
        do {
            let classRef = db.collection("Classes").document(classID)
            
            // Fetch the current students array
            var currentStudents = try await classRef.getDocument().data()?["students"] as? [String] ?? []

            // Append the new studentID to the array
            currentStudents.append(studentID)

            // Update the "students" field in the document with the modified array
            try await classRef.updateData(["students": currentStudents])

        } catch {
            throw error
        }
    }
    
    func addStudentToSchool(studentID: String, schoolID: String) async throws {
        do {
            let schoolRef = db.collection("SchoolUsers").document(schoolID)
            
            // Fetch the current students array
            var currentStudents = try await schoolRef.getDocument().data()?["students"] as? [String] ?? []

            // Append the new studentID to the array
            currentStudents.append(studentID)

            // Update the "students" field in the document with the modified array
            try await schoolRef.updateData(["students": currentStudents])

        } catch {
            throw error
        }
    }

    
    func addAnnouncement(_ announcement: Announcement) async throws -> String {
        let announcementData: [String: Any] = [
            "id": announcement.id,
            "title": announcement.title,
            "type": announcement.type,
            "photo": announcement.photo,
            "dateEvent": announcement.dateEvent,
            "writerName": announcement.writerName,
            "description": announcement.description
        ]
        
        do {
            let documentReference = try await db.collection("Announcements").addDocument(data: announcementData)
            // let documentReference = db.collection("Classes").addDocument(data: classData)
            // let documentReference = try await db.collection("Classes").addDocument(data: classData)
            
            let documentID = documentReference.documentID
            let announcementRef = db.collection("Announcements").document(documentID)
            
            try await announcementRef.updateData(["id": documentID])
            return documentID
        } catch {
            throw error
        }
    }
    
    func addAnnouncementToStudent(announcementID: String, studentID: String) async throws {
        // Reference to the document you want to update
        let documentRef = db.collection("Students").document(studentID)
        
        do {
            try await documentRef.updateData([
                "announcements": FieldValue.arrayUnion([announcementID])
            ])
            print("Document updated successfully.")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func addClassToUser(classID: String, userID: String) async throws {
        // Reference to the document you want to update
        let documentRef = db.collection("SchoolUsers").document(userID)
        
        do {
            try await documentRef.updateData([
                "roomClasses": FieldValue.arrayUnion([classID])
            ])
            print("Document updated successfully.")
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func addAnnouncementToUser(announcementID: String, userID: String) async throws {
        // Reference to the document you want to update
        let documentRef = db.collection("SchoolUsers").document(userID)
        
        do {
            try await documentRef.updateData([
                "announcements": FieldValue.arrayUnion([announcementID])
            ])
            print("Document updated successfully.")
            
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    // MARK: user functions
    func fetchUser(userAuthID: String, collection: String) async throws -> SchoolUser {
        let userRef = db.collection("SchoolUsers")
        print(userAuthID)
        let query = userRef.whereField("authID", isEqualTo: userAuthID)
        
        do {
            let querySnapshot = try await query.getDocuments()
            
            if let document = querySnapshot.documents.first {
                let data = document.data()
                
                let id = data["id"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let userName = data["userName"] as? String ?? ""
                let roomClasses = data["roomClasses"] as? [String] ?? [""]
                let announcements = data["announcements"] as? [String] ?? [""]
                let chatMessages = data["chatMessages"] as? [String] ?? ["Error fetching chat messages"]
                let studentID = data["studentID"] as? String ?? ""
                let userType = data["userType"] as? String ?? ""
                let studentName = data["studentName"] as? String ?? "Error fetching student name"
                let authID = data["authID"] as? String ?? "Error"
                let students = data["students"] as? [String] ?? ["Error"]
                
                let user = SchoolUser(id: id, authID: authID, roomClasses: roomClasses, announcements: announcements, chatMessages: chatMessages, activities: [""], email: email, studentID: studentID, studentName: studentName, userType: userType, userName: userName, students: students)
                
                return user
            } else {
                throw UserError.noDocument
            }
        } catch {
            print("Error getting diary entries: \(error)")
            throw error
        }
    }
    
    
    enum UserError: Error {
        case noDocument
        case invalidData
        case other(Error)
    }
    
    func addUser(_ user: SchoolUser) async throws -> String {
        let userData: [String: Any] = [
            "id": user.id,
            "authID": user.authID,
            "email": user.email,
            "userName": user.userName,
            "chatMessages": user.chatMessages,
            "roomClasses": user.roomClasses,
            "announcements": user.announcements,
            "userType": user.userType,
            "studentID": user.studentID,
            "studentName": user.studentName
        ]
        
        do {
            let documentReference = try await db.collection("SchoolUsers").addDocument(data: userData)
            let documentID = documentReference.documentID
            let userRef = db.collection("SchoolUsers").document(documentID)
            
            try await userRef.updateData(["id": documentID])
            
            return documentID
        } catch {
            throw error
        }
    }
    
    
}
