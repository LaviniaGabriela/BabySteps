//
//  StudentListView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct StudentListView: View {
    @ObservedObject var firebaseManager: FirebaseManager
    var classID: String
    @State var className: String = ""
    @State var roomClass: RoomClass?
    @State var students: [Student] = []
    @Binding var selectedStudentID: String?
    @State private var searchText = ""
    @State private var showNewStudentSheet: Bool = false
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
                        List(selection: $selectedStudentID) {
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
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showNewStudentSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }

                        }
                    }
                    .sheet(isPresented: $showNewStudentSheet) {
                        CreateStudentView(showSheet: $showNewStudentSheet, classID: classID)
                    }
                }
            }
            .navigationTitle(className)
            .task(id: classID, {
                print("ID da classe: \(classID)\n")
                firebaseManager.fetchClass(withID: classID) { fetchedClass, error in
                    if let fetchedClass = fetchedClass {
                        roomClass = fetchedClass
                        className = roomClass!.name
                        students = []
                        
                        if !roomClass!.students.isEmpty {
                            for studentID in roomClass!.students {
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
            })
        }
    }
}

//struct StudentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentListView(firebaseManager: FirebaseManager)
//    }
//}
