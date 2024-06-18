//
//  ReportCard.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct ReportCard: View {
    @State var title: String
    @ObservedObject var firebaseManager: FirebaseManager
    @Binding var diary: Diary
    @Binding var observations: String
    @State var selection = 0
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                switch title {
                case "Attendance":
                    Image(systemName: "face.smiling")
                        .font(.callout)
                        .bold()
                case "Water":
                    Image(systemName: "drop")
                        .font(.callout)
                        .bold()
                case "Milk":
                    Image(systemName: "mug")
                        .font(.callout)
                        .bold()
                case "Fruit":
                    Image(systemName: "carrot")
                        .font(.callout)
                        .bold()
                case "Lunch":
                    Image(systemName: "fork.knife.circle")
                        .font(.callout)
                        .bold()
                case "Snack":
                    Image(systemName: "takeoutbag.and.cup.and.straw")
                        .font(.callout)
                        .bold()
                default:
                    Image(systemName: "")
                }

                Text(title)
                    .font(.callout)
                    .bold()
            }
            
            

            // botões de seleção
            HStack {
                if title == "Attendance" {
                    let selections = [["Present", "face.smiling"], ["Absent", "face.dashed"]]
                    
                    Spacer()
                    
                    ForEach(0..<selections.count, id: \.self) { index in
                        VStack {
                            ZStack {
                                Circle()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(selection == index ? .accentColor : Color(.systemGray5))
                                
                                Image(systemName: selections[index][1])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    if index == 0 {
                                        firebaseManager.updateDiaryProperty(diaryID: diary.id, propertyName: "attendance", newValue: true) { error in
                                            if let error = error {
                                                print("error updating diary property")
                                            } else {
                                                diary.attendance = true
                                            }
                                        }
                                    } else {
                                        firebaseManager.updateDiaryProperty(diaryID: diary.id, propertyName: "attendance", newValue: false) { error in
                                            if let error = error {
                                                print("error updating diary property")
                                            } else {
                                                diary.attendance = false
                                            }
                                        }
                                    }
                                    
                                    selection = index
                                }
                            }
                            
                            Text(selections[index][0])
                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                    .onAppear {
                        selection = diary.attendance ? 0 : 1
                    }
                } else {
                    
                    if title == "Water" {
                        let selections = [["All", "drop.fill"], ["Half", "drop.fill"], ["Few", "drop.fill"], ["Did Not Accept", "drop.fill"]]
                        
                        Spacer()
                        
                        ForEach(0..<selections.count, id: \.self) { index in
                            ReportSelection(firebaseManager: firebaseManager, selection: $selection, propertyName: "water", selections: selections, satisfaction: $diary.water.satisfaction, index: index, diaryID: diary.id)
                            
                            Spacer()
                        }
                        .onAppear {
                            selection = diary.water.satisfaction
                        }
                    }
                    else if title == "Milk" {
                        let selections = [["All", "mug.fill"], ["Half", "mug.fill"], ["Few", "mug.fill"], ["Did Not Accept", "mug"], ["At Home", "house"]]

                        Spacer()
                        
                        ForEach(0..<selections.count, id: \.self) { index in
                            ReportSelection(firebaseManager: firebaseManager, selection: $selection, propertyName: "milk", selections: selections, satisfaction: $diary.milk.satisfaction, index: index, diaryID: diary.id)
                        
                            Spacer()
                        }
                        .onAppear {
                            selection = diary.milk.satisfaction
                         
                        }
                    }
                    
                    else if title == "Fruit" {
                        let selections = [["All", "carrot.fill"], ["Half", "carrot.fill"], ["Few", "carrot.fill"], ["Did Not Accept", "carrot"]]

                        Spacer()
                        
                        ForEach(0..<selections.count, id: \.self) { index in
                            ReportSelection(firebaseManager: firebaseManager, selection: $selection, propertyName: "fruit", selections: selections, satisfaction: $diary.milk.satisfaction, index: index, diaryID: diary.id)
                        
                            Spacer()
                        }
                        .onAppear {
                            selection = diary.fruit.satisfaction

                        }
                    }
                    
                    else if title == "Lunch" {
                        let selections = [["All", "fork.knife.circle.fill"], ["Half", "fork.knife.circle.fill"], ["Few", "fork.knife.circle.fill"], ["Did Not Accept", "fork.knife.circle"]]

                        Spacer()
                        
                        ForEach(0..<selections.count, id: \.self) { index in
                            ReportSelection(firebaseManager: firebaseManager, selection: $selection, propertyName: "lunch", selections: selections, satisfaction: $diary.milk.satisfaction, index: index, diaryID: diary.id)
                        
                            Spacer()
                        }
                        .onAppear {
                            selection = diary.fruit.satisfaction
                          
                        }
                    }
                    
                    else if title == "Snack" {
                        let selections = [["All", "takeoutbag.and.cup.and.straw.fill"], ["Half", "takeoutbag.and.cup.and.straw.fill"], ["Few", "takeoutbag.and.cup.and.straw.fill"], ["Did Not Accept", "takeoutbag.and.cup.and.straw"]]

                        Spacer()
                        
                        ForEach(0..<selections.count, id: \.self) { index in
                            ReportSelection(firebaseManager: firebaseManager, selection: $selection, propertyName: "snackTime", selections: selections, satisfaction: $diary.milk.satisfaction, index: index, diaryID: diary.id)
                        
                            Spacer()
                        }
                        .onAppear {
                            selection = diary.fruit.satisfaction
                            
                        }
                    }
                }
                
            }
            .padding()
            
            TextField("Observações...", text: $observations, axis: .horizontal)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                    
                }
                .onSubmit {
                    var propertyName = ""
                    var propertyContent: [[String: Any]] = [[:]]
                    
                    switch title {
                    case "Water":
                        propertyName = "water"
                        propertyContent = [["satisfaction": diary.water.satisfaction], ["observation": diary.water.observation]]
                    case "Milk":
                        propertyName = "milk"
                        propertyContent = [["satisfaction": diary.milk.satisfaction], ["observation": diary.milk.observation]]
                    case "Fruit":
                        propertyName = "fruit"
                        propertyContent = [["satisfaction": diary.fruit.satisfaction], ["observation": diary.fruit.observation]]
                    case "Lunch":
                        propertyName = "lunch"
                        propertyContent = [["satisfaction": diary.lunch.satisfaction], ["observation": diary.lunch.observation]]
                    case "Snack":
                        propertyName = "snackTime"
                        propertyContent = [["satisfaction": diary.snackTime.satisfaction], ["observation": diary.snackTime.observation]]
                    default:
                        propertyName = "attendanceObservation"
                    }
                    
                    if propertyName != "attendanceObservation" {
                        firebaseManager.updateNestedDiaryProperty(diaryID: diary.id, parentPropertyName: propertyName, childPropertyName: "observation", newValue: observations) { error in
                            if let error = error {
                                print("Error updating nested diary property: \(error)")
                            } else {
                                print("Nested diary property updated successfully")
                            }
                        }
                    } else {
                        firebaseManager.updateDiaryProperty(diaryID: diary.id, propertyName: propertyName, newValue: observations) { error in
                            if let error = error {
                                print("Error updating nested diary property: \(error)")
                            } else {
                                print("Nested diary property updated successfully")
                            }
                        }
                    }
                    

                }
            
            
            
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        }
    }
}

struct ReportSelection: View {
    @ObservedObject var firebaseManager: FirebaseManager
    @Binding var selection: Int
    var propertyName: String
    var selections: [[String]]
    @Binding var satisfaction: Int
    var index: Int
    var diaryID: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(selection == index ? .accentColor : Color(.systemGray5))
                
                Image(systemName: selections[index][1])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }
            .onTapGesture {
                withAnimation(.spring()) {
    
                    firebaseManager.updateNestedDiaryProperty(diaryID: diaryID, parentPropertyName: propertyName, childPropertyName: "satisfaction", newValue: index) { error in
                        if let error = error {
                            print("Error updating nested diary property: \(error)")
                        } else {
                            print("Nested diary property updated successfully")
                            selection = index
                        }
                    }
                }
            }
            
            Text(selections[index][0])
                .font(.footnote)
        }
    }
}

//struct ReportCard_Previews: PreviewProvider {
//
//    @State var diary = Diary(date: Date(),
//                      water: Diary.DiaryReport(satisfaction: .half, observation: "Drank less water"),
//                      milk: Diary.DiaryReport(satisfaction: .few, observation: "Skipped milk today"),
//                      fruit: Diary.DiaryReport(satisfaction: .didNotAccept, observation: "No fruits today"),
//                      lunch: Diary.DiaryReport(satisfaction: .didNotAccept, observation: "Ate lunch at home"),
//                      snackTime: Diary.DiaryReport(satisfaction: .all, observation: ""),
//                      attendance: true,
//                      attendanceObservation: "Missed morning class",
//                      completed: true)
//
//    static var previews: some View {
//        ReportCard(title: "Snack",
//                   diary: $diary, observations: $diary.water.observation)
//    }
//}
