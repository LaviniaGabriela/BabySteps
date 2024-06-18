//
//  CreateClassView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct CreateClassView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var userManager: UserManager
    @Binding var showSheet: Bool
    @State private var className: String = ""
    @State var addedStudents: [Student] = []
    @State var showAllStudentsList = false
    @State private var classShift: String = ""
    @State var showErrorAlert = false
    
    var body: some View {
        if userManager.userAuthID == "" {
            ProfileView()
        } else {
            NavigationView {
                Form {
                    Section(header: Text("Student Details")){
                        TextField("Class Name", text: $className)
                        TextField("Shift", text: $classShift)
                    }
                    
                    Button("Select Students") {
                        showAllStudentsList = true
                    }
                    .sheet(isPresented: $showAllStudentsList) {
                        AllStudentsListView(showModal: $showAllStudentsList, addedStudents: $addedStudents)
                            .environmentObject(firebaseManager)
                    }
                    .alert(isPresented: $showErrorAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text("Failed to save the class."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Section(header: Text("Selected Students")) {
                        ForEach(addedStudents, id: \.self) { student in
                            Text(student.name)
                        }
                    }
                }
                .navigationBarTitle("New Class")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Save") {
                    var addedStudentsIDs: [String] = []
                    
                    for student in addedStudents {
                        addedStudentsIDs.append(student.id)
                    }
                    
                    let newClass = RoomClass(id: "", shift: classShift, name: className, students: addedStudentsIDs)
                    
                    Task {
                        do {
                            let documentID = try await firebaseManager.addClass(newClass)
                            
                            do {
                                try await firebaseManager.addClassToUser(classID: documentID, userID: userManager.userID)
                            } catch {
                                print("Error updating document: \(error)")
                            }
                            
                            showAllStudentsList = false
                            showSheet = false
                        } catch {
                            showErrorAlert = true
                        }
                    }
                    
                    
                })
                
            }
        }
    }
}

struct AllStudentsListView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var showModal: Bool
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var allStudents: [Student] = []
    @Binding var addedStudents: [Student]
    @State private var searchText = ""
    private var filteredStudents: [Student] {
        if searchText.isEmpty {
            return allStudents
        } else {
            return allStudents.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
            List {
                ForEach(allStudents, id: \.self) { student in
                    Button(action: {
                        withAnimation {
                            if let index = addedStudents.firstIndex(where: { $0.id == student.id }) {
                                addedStudents.remove(at: index)
                            } else {
                                addedStudents.append(student) // Select
                            }
                        }
                        
                    }) {
                        HStack {
                            Text(student.name)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            if addedStudents.contains(where: { $0.id == student.id }) {
                                Image(systemName: "checkmark")
                            }
                        }
                        
                    }
                    
                }
            }

            .task {
                for studentID in userManager.students {
                    firebaseManager.fetchStudent(withID: studentID) { fetchedStudent, error in
                        if let fetchedStudent = fetchedStudent {
                            allStudents.append(fetchedStudent)
                        }
                    }
                }
                
            }
        
        
    }
}

//struct CreateClassView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateClassView()
//    }
//}
