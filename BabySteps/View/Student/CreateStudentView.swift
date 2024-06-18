//
//  CreateStudentView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import FirebaseAuth

struct CreateStudentView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @Binding var showSheet: Bool
    @State var showErrorAlert = false
    var classID: String
    @State var name = ""
    @State var gender = ""
    @State var address = ""
    @State var birthDate = ""
    @State var age = ""
    @State var email = ""
    @State var mainPhone = ""
    @State var otherPhone = ""
    @State var ingressDate = ""
    @State var foodRestrictions = ""
    @State var allergies = ""
    @State var bloodType = ""
    @State var preferredHospital = ""
    @State var missingVaccines = ""
    @State var studentPhoto = ""
    @State var studentClass = ""
    @State var firstResponsible = ""
    @State var secondaryResponsible = ""
    @State var studentID = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Details")){
                    TextField("Student Name", text: $name)
                    TextField("Gender", text: $gender)
                    TextField("Birth Date", text: $birthDate)
                    TextField("Age", text: $age)
                    TextField("Birth Date", text: $birthDate)
                    TextField("First Responsible", text: $firstResponsible)
                    TextField("Secondary Responsible", text: $secondaryResponsible)
                    TextField("Ingress Date", text: $ingressDate)
                }
                
                Section(header: Text("Tecnical Details")){
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                    TextField("Main Phone", text: $mainPhone)
                    TextField("Other Phone", text: $otherPhone)
                    TextField("Birth Date", text: $birthDate)
                    TextField("Age", text: $age)
                    TextField("Birth Date", text: $birthDate)
                }
                
                Section(header: Text("Health Details")){
                    TextField("Food Restrictions", text: $foodRestrictions)
                    TextField("Allergies", text: $allergies)
                    TextField("Preferred Hospital", text: $preferredHospital)
                    TextField("Blood Type", text: $bloodType)
                    TextField("Birth Date", text: $birthDate)
                    TextField("Missing Vaccines", text: $missingVaccines)
                }
                
                
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Failed to save the class."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitle("New Student")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Save") {
                
                let password = UUID().uuidString
                
                #warning("update parent and school ids after parent is created in firebase")
                let newStudent = Student(name: name, gender: gender, address: address, birthDate: birthDate, age: age, mainPhone: mainPhone, otherPhone: otherPhone, ingressDate: ingressDate, foodRestrictions: [foodRestrictions], allergies: [allergies], bloodType: bloodType, preferredHospital: preferredHospital, missingVaccines: [missingVaccines], studentPhoto: "", studentClass: classID, firstResponsible: firstResponsible, secondaryResponsible: secondaryResponsible, email: email, password: password, parentID: "", schoolID: "")
                
                Task {
                    do {
                        let documentID = try await firebaseManager.addStudent(newStudent)
                        studentID = documentID
                        
                        do {
                            try await firebaseManager.addStudentToClass(studentID: documentID, classID: classID)
                            try await firebaseManager.addStudentToSchool(studentID: documentID, schoolID: userManager.userID)
                 
                        } catch {
                            print("Error adding student: \(error)")
                        }

                        showSheet = false
                    } catch {
                        showErrorAlert = true
                    }
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if (error != nil) {
                            print("\nError creating user\n")
                        } else {
                            print("\n\ncreateddd\n\n")
                            if let user = authResult?.user {
                                let userAuthID = user.uid
                                
                                Task {
                                    do {
                                        let newUserID = try await firebaseManager.addUser(SchoolUser(authID: userAuthID, roomClasses: [], announcements: [], chatMessages: [], activities: [], email: email, studentID: studentID, studentName: name, userType: "Parent", userName: firstResponsible, students: []))
                                        
                                        print("User created successfully with auth ID: \(newUserID)")
                                        
                                    } catch {
                                        print("Error updating document: \(error)")
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

//struct CreateStudentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateStudentView()
//    }
//}
