//
//  StudentDiary.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI
import UIKit

struct StudentDiary: View {
    @Environment(\.colorScheme) var colorScheme
    @State var observations = ""
    @ObservedObject var firebaseManager: FirebaseManager
    let studentID: String
    @State var student: Student? = nil
    @State var diary = Diary(id: "", date: "",
                             water: Diary.DiaryReport(satisfaction: 4, observation: ""),
                             milk: Diary.DiaryReport(satisfaction: 4, observation: ""),
                             fruit: Diary.DiaryReport(satisfaction: 4, observation: ""),
                             lunch: Diary.DiaryReport(satisfaction: 4, observation: ""),
                             snackTime: Diary.DiaryReport(satisfaction: 4, observation: ""),
                             attendance: false,
                             attendanceObservation: "",
                             completed: false)
    @State private var date = Calendar.current.startOfDay(for: Date())
    @State private var showDatePicker = false
    @State private var showDiary = true
    @State private var diaryAvailable = false
    @State private var showRecord = true
    @State private var showingAlert = false
    
    private let errorDiary = Diary(id: "", date: "",
                                       water: Diary.DiaryReport(satisfaction: 4, observation: "Error fetching data"),
                                       milk: Diary.DiaryReport(satisfaction: 4, observation: "Error fetching data"),
                                       fruit: Diary.DiaryReport(satisfaction: 4, observation: "Error fetching data"),
                                       lunch: Diary.DiaryReport(satisfaction: 4, observation: "Error fetching data"),
                                       snackTime: Diary.DiaryReport(satisfaction: 4, observation: ""),
                                       attendance: false,
                                       attendanceObservation: "Error fetching data",
                                       completed: false)
    
    
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
            
            if student == nil {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // brief student info and photo
                        VStack(spacing: 8){
                            AsyncImage(url: URL(string: student?.studentPhoto ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 112, height: 112)
                                    .mask(
                                        Circle()
                                            .frame(width: 112, height: 112)
                                    )
                            } placeholder: {
                                Color.gray
                                    .frame(width: 112, height: 112)
                                    .mask(
                                        Circle()
                                            .frame(width: 112, height: 112)
                                    )
                            }

                            
                            Text(student?.name as? String ?? "Error fetching name")
                                .font(.title2)
                                .bold()
                            
                            Text(student?.age as? String ?? "Error fetching age")
                                .font(.headline)
                                .fontWeight(.regular)
                            
                            Text(student?.firstResponsible as? String ?? "Error fetching responsible")
                                .font(.headline.italic())
                                .foregroundColor(.gray)
                                
                        }
                        .padding(.bottom, 8)
                        
                        // diary title
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Diary")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                Image(systemName: showDiary ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.accentColor)
                                    .bold()
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            showDiary.toggle()
                                        }
                                    }
                            }
                            
                        }
                        
                        

                        if showDiary {
                            // date picker
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                                
                                Text(formatDate(date: date))
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                                    .padding(.vertical)
                                
                                Image(systemName: "chevron.right")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.accentColor)
                                
                                Spacer()
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showDatePicker.toggle()
                                }
                            }
                            
                            // diary cards
                            if diaryAvailable {

                                // report cards
                                ReportCard(title: "Attendance", firebaseManager: firebaseManager, diary: $diary, observations: $diary.attendanceObservation)
                                
                                ReportCard(title: "Water", firebaseManager: firebaseManager, diary: $diary, observations: $diary.water.observation)
                                
                                ReportCard(title: "Milk", firebaseManager: firebaseManager, diary: $diary, observations: $diary.milk.observation)
                                
                                ReportCard(title: "Fruit", firebaseManager: firebaseManager, diary: $diary, observations: $diary.fruit.observation)
                                
                                ReportCard(title: "Lunch", firebaseManager: firebaseManager, diary: $diary, observations: $diary.lunch.observation)
                                
                                ReportCard(title: "Snack", firebaseManager: firebaseManager, diary: $diary, observations: $diary.snackTime.observation)
                            } else {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("No diary records found.")
                                            .padding()
                                        
                                        Button("New Diary Entry") {
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "dd/MM/yyyy"
                                            
                                            var newDiary = Diary(id: "",
                                                    studentId: studentID,
                                                    date: dateFormatter.string(from: date),
                                                    water: Diary.DiaryReport(satisfaction: 0, observation: ""),
                                                    milk: Diary.DiaryReport(satisfaction: 0, observation: ""),
                                                    fruit: Diary.DiaryReport(satisfaction: 0, observation: ""),
                                                    lunch: Diary.DiaryReport(satisfaction: 0, observation: ""),
                                                    snackTime: Diary.DiaryReport(satisfaction: 0, observation: ""),
                                                    attendance: true,
                                                    attendanceObservation: "",
                                                    completed: false)
                                            
                                             
                                            Task {
                                                do {
                                                    let documentID = try await firebaseManager.addDiary(newDiary)
                                                    newDiary.id = documentID
                                                    diary = newDiary
                                                    diaryAvailable = true
                                                } catch {
                                                    showingAlert = true
                                                }
                                            }
                                            
//                                            firebaseManager.addDiary(diary: newDiary) { documentID, error in
//                                                if let error = error {
//                                                    print("Error adding diary: \(error)")
//                                                } else if let documentID = documentID {
//                                                    newDiary.id = documentID
//
//                                                }
//                                            }
                                        }
                                        .padding(.bottom)
                                        .alert("Error saving diary", isPresented: $showingAlert) {
                                                    Button("OK", role: .cancel) { }
                                                }
                                    }
                                    Spacer()
                                }.background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                }
                            }
                        }
                        

                        // student record title
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Student Record")
                                    .font(.title2)
                                    .bold()
                                
                                Spacer()
                                
                                
                                Image(systemName: showRecord ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.accentColor)
                                    .bold()
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            showRecord.toggle()
                                        }
                                    }
                            }
                            
                            
                        }
                        
                        // student record cards
                        if showRecord {
                            StudentRecordCardView(student: student)
                            
                            StudentHealthCardView(student: student)
                            
                            StudentLoginInfoCardView(student: student)
                        }
                    }
                    .padding()
                }.scrollIndicators(ScrollIndicatorVisibility.hidden)
            }
            
            
            // date picker
            if showDatePicker {
                ZStack {
                    Color(.gray).opacity(0.5)
                        .onTapGesture {
                            showDatePicker = false
                        }
                    HStack {
                        DatePicker(
                                "Start Date",
                                selection: $date,
                                displayedComponents: [.date]
                            )
                            .frame(width: 400)
                            .datePickerStyle(.graphical)
                            .padding()
                            .onChange(of: date) { newValue in
                                withAnimation(.spring()) {
                                    showDatePicker = false
                                    date = Calendar.current.startOfDay(for: newValue)
                                    diaryAvailable = false
                                    
                                    firebaseManager.fetchDiary(studentID: studentID, on: date) { fetchedDiary, error in
                                        if let error = error {
                                            diaryAvailable = false
                                            print("Error fetching diary entries: \(error)")
                                        } else if let fetchedDiary = fetchedDiary {
                                            diary = fetchedDiary
                                            diaryAvailable = true
                                        }
                                    }
                                }
                            }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showDatePicker.toggle()
                                }
                            }
                    }
                }
  
            }
            
            
            
        }
        .onAppear {
            firebaseManager.fetchStudent(withID: studentID) { fetchedStudent, error in
                if let error = error {
                    diaryAvailable = false
                    print("Error fetching student: \(error)")
                } else if let fetchedStudent = fetchedStudent {
                    student = fetchedStudent
                }
            }

            firebaseManager.fetchDiary(studentID: studentID, on: date) { fetchedDiary, error in
                if let error = error {
                    diaryAvailable = false
                    print("Error fetching diary entries: \(error)")
                } else if let fetchedDiary = fetchedDiary {
                    diary = fetchedDiary
                    diaryAvailable = true
                }
            }
        }
        .onChange(of: studentID) { newValue in
            withAnimation {
                student = nil
                
                firebaseManager.fetchStudent(withID: newValue) { fetchedStudent, error in
                    if let error = error {
                        diaryAvailable = false
                        print("Error fetching student: \(error)")
                    } else if let fetchedStudent = fetchedStudent {
                        student = fetchedStudent
                    }
                }

                firebaseManager.fetchDiary(studentID: newValue, on: date) { fetchedDiary, error in
                    if let error = error {
                        diaryAvailable = false
                        print("Error fetching diary entries: \(error)")
                    } else if let fetchedDiary = fetchedDiary {
                        diary = fetchedDiary
                        diaryAvailable = true
                    }
                }
            }
            
        }
    
    }
    
    private func formatDate(date: Date) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "E, d MMMM"
       return dateFormatter.string(from: date)
   }
}

//struct StudentDiary_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentDiary(firebaseManager: FirebaseManager(), studentID: "EGig5KwjpgFJjYNhFQYh", student: Student(
//            id: "",
//            name: "João Gabriel",
//            responsible: ["Mariana Gabriel", "Henrique da Silva"],
//            address: "123 Main Street, City",
//            birthDate: Date(),
//            age: "18",
//            mainPhone: "123-456-7890",
//            otherPhone: "987-654-3210",
//            ingressDate: Date(),
//            foodRestrictions: ["No nuts", "Gluten-free"],
//            allergies: ["Pollen", "Cats"],
//            bloodType: "A+",
//            preferredHospital: "City General Hospital",
//            missingVaccines: ["Flu", "HPV"],
//            studentPhoto: "foto-criança",
//            studentClass: ""
//        ))
//    }
//}
//        ))
//    }
//}
