//
//  ChatListView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation
import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var userManager: UserManager
    @State var className: String = ""
    @State var roomClass: RoomClass?
    @State var students: [Student] = []
    @Binding var selectedChatID: String?
    @State private var searchText = ""
    private var filteredStudents: [Student] {
        if searchText.isEmpty {
            return students
        } else {
            return students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var selected: Student?
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad { // ipad
            VStack {
                if students.isEmpty {
                    ProgressView()
                } else {
                    NavigationStack {
                        List(selection: $selectedChatID) {
                            ForEach(filteredStudents, id: \.self) { student in
                                HStack {
                                    // student photo
                                    AsyncImage(url: URL(string: student.studentPhoto)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 54, height: 54)
                                            .mask(
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                            )
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 54, height: 54)
                                            .mask(
                                                Circle()
                                                    .frame(width: 54, height: 54)
                                            )
                                    }
                                    
                                    Text(student.name)
                                }.tag(student.id)
                            }
                        }
                        .searchable(text: $searchText)
                    }
                }
            }
            .navigationTitle("Chat")
            .task {
                if !userManager.students.isEmpty {
                    for studentID in userManager.students {
                        firebaseManager.fetchStudent(withID: studentID) { fetchedStudent, error in
                            if let fetchedStudent = fetchedStudent {
                                students.append(fetchedStudent)
                                print("adicionou: \(fetchedStudent.name)")
                            }
                        }
                    }
                }
            }
        }
    }
}
