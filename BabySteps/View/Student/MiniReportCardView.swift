//
//  MiniReportCardView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct MiniReportCardView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var diary = Diary(id: "", studentId: "", date: "", water: Diary.DiaryReport(satisfaction: 3, observation: ""), milk: Diary.DiaryReport(satisfaction: 3, observation: ""), fruit: Diary.DiaryReport(satisfaction: 3, observation: ""), lunch: Diary.DiaryReport(satisfaction: 3, observation: ""), snackTime: Diary.DiaryReport(satisfaction: 3, observation: ""), attendance: true, attendanceObservation: "faltou na primeira aula", completed: true)
    @Binding var diaryAvailable: Bool
    var categories1: [String] = ["Attendance", "Water", "Milk"]
    var categories2: [String] = ["Fruit", "Lunch", "Snack"]
    
    var body: some View {
        
        VStack(alignment: .center) {
           HStack {
                ForEach(categories1, id: \.self) { category in
                    GeometryReader { geo in
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                Text(category)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                
                                if category == "Attendance" {
                                    ZStack {
                                        Circle()
                                            .frame(width: 48, height: 48)
                                            .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                        
                                        if diaryAvailable {
                                            Image(systemName: diary.attendance ? "face.smiling" : "face.dashed")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        } else {
                                            Image(systemName: "face.smiling.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        
                                        
                                    }
                                    if diaryAvailable {
                                        Text(diary.attendance ? "Present" : "Absent")
                                            .minimumScaleFactor(0.5)
                                    } else {
                                        Text("-")
                                    }
                                    
                                    
                                } else {
                                    
                                    switch category {
                                        case "Water":
                                            ZStack {
                                                Circle()
                                                    .frame(width: 48, height: 48)
                                                    .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                                
                                                Image(systemName: "drop.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.semibold)
                                                
                                                
                                            }
                                        
                                        if diaryAvailable {
                                            switch diary.water.satisfaction {
                                            case 0:
                                                Text("All")
                                            case 1:
                                                Text("Half")
                                            case 2:
                                                Text("Few")
                                            case 3:
                                                Text("Did not accept")
                                            case 4:
                                                Text("At Home")
                                            default:
                                                Text("Did not accept")
                                            }
                                        }  else {
                                            Text("-")
                                        }
                                            
                                            
                                    case "Milk":
                                        ZStack {
                                            Circle()
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                            
                                            Image(systemName: "mug.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                            
                                            
                                        }
                                    
                                        if diaryAvailable {
                                            switch diary.milk.satisfaction {
                                            case 0:
                                                Text("All")
                                            case 1:
                                                Text("Half")
                                            case 2:
                                                Text("Few")
                                            case 3:
                                                Text("Did not accept")
                                            case 4:
                                                Text("At Home")
                                            default:
                                                Text("Did not accept")
                                            }
                                        } else {
                                            Text("-")
                                        }
                                       
                                        
                                    default:
                                        ZStack {
                                            Circle()
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                            
                                            Image(systemName: category)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                            
                                            
                                        }
                                        Text(category)
                                    }
                                }
                                
                            }
                            Spacer()
                        }
                        
                    }
                }
            }
            
            
            Divider()
                .padding(.bottom)
            
            HStack {
                ForEach(categories2, id: \.self) { category in
                    GeometryReader { geo in
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                Text(category)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                
                                if category == "Fruit" {
                                    ZStack {
                                        Circle()
                                            .frame(width: 48, height: 48)
                                            .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                        
                                        Image(systemName: "carrot.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
           
                                    }
                                    if diaryAvailable {
                                        switch diary.water.satisfaction {
                                        case 0:
                                            Text("All")
                                        case 1:
                                            Text("Half")
                                        case 2:
                                            Text("Few")
                                        case 3:
                                            Text("Did not accept")
                                        case 4:
                                            Text("At Home")
                                        default:
                                            Text("Did not accept")
                                        }
                                    }  else {
                                        Text("-")
                                    }
                                    
                                    
                                } else {
                                    
                                    switch category {
                                        case "Lunch":
                                            ZStack {
                                                Circle()
                                                    .frame(width: 48, height: 48)
                                                    .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                                
                                                Image(systemName: "fork.knife")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.semibold)
                                                
                                                
                                            }
                                        
                                        if diaryAvailable {
                                            switch diary.water.satisfaction {
                                            case 0:
                                                Text("All")
                                            case 1:
                                                Text("Half")
                                            case 2:
                                                Text("Few")
                                            case 3:
                                                Text("Did not accept")
                                            case 4:
                                                Text("At Home")
                                            default:
                                                Text("Did not accept")
                                            }
                                        }  else {
                                            Text("-")
                                        }
                                            
                                            
                                    case "Snack":
                                        ZStack {
                                            Circle()
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                            
                                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                            
                                            
                                        }
                                    
                                        if diaryAvailable {
                                            switch diary.milk.satisfaction {
                                            case 0:
                                                Text("All")
                                            case 1:
                                                Text("Half")
                                            case 2:
                                                Text("Few")
                                            case 3:
                                                Text("Did not accept")
                                            case 4:
                                                Text("At Home")
                                            default:
                                                Text("Did not accept")
                                            }
                                        } else {
                                            Text("-")
                                        }
                                       
                                        
                                    default:
                                        ZStack {
                                            Circle()
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(diaryAvailable ? .accentColor : Color(.systemGray5))
                                            
                                            Image(systemName: category)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                            
                                            
                                        }
                                        Text(category)
                                    }
                                }
                                
                            }
                            Spacer()
                        }
                        
                    }
                }
            }
            
        }
        .frame(height: 300)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        }
        .onAppear {
            Task {
                do {
                    let fetchedUser = try await firebaseManager.fetchUser(userAuthID: userManager.userAuthID, collection: "ParentUsers")
                    userManager.userName = fetchedUser.userName
                    userManager.classes = fetchedUser.roomClasses
                    userManager.studentID = fetchedUser.studentID
                    userManager.email = fetchedUser.email
                    
                    firebaseManager.fetchDiary(studentID: userManager.studentID ?? "", on: Date()) { fetchedDiary, error in
                        if let error = error {
                            diaryAvailable = false
                            print("Error fetching diary entries: \(error)")
                        } else if let fetchedDiary = fetchedDiary {
                            withAnimation(.spring()) {
                                diary = fetchedDiary
                                diaryAvailable = true
                            }
                            
                        }
                    }
                } catch {
                    print("Error fetching user data: \(error)")
                }
            }
            
        }
        .task {
            do {
                let fetchedUser = try await firebaseManager.fetchUser(userAuthID: userManager.userAuthID, collection: "ParentUsers")
                userManager.userName = fetchedUser.userName
                userManager.classes = fetchedUser.roomClasses
                userManager.studentID = fetchedUser.studentID
                userManager.email = fetchedUser.email
                
                firebaseManager.fetchDiary(studentID: userManager.studentID ?? "", on: Date()) { fetchedDiary, error in
                    if let error = error {
                        diaryAvailable = false
                        print("Error fetching diary entries: \(error)")
                    } else if let fetchedDiary = fetchedDiary {
                        withAnimation(.spring()) {
                            diary = fetchedDiary
                            diaryAvailable = true
                        }
                        
                    }
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
            
        }
    }
}

//struct MiniReportCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniReportCardView(diary: Diary(id: "", studentId: "", date: "", water: Diary.DiaryReport(satisfaction: 3, observation: ""), milk: Diary.DiaryReport(satisfaction: 3, observation: ""), fruit: Diary.DiaryReport(satisfaction: 3, observation: ""), lunch: Diary.DiaryReport(satisfaction: 3, observation: ""), snackTime: Diary.DiaryReport(satisfaction: 3, observation: ""), attendance: true, attendanceObservation: "faltou na primeira aula", completed: true), diaryAvailable: false)
//    }
//}
