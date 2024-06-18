//
//  CreateNewMenuView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct CreateNewMenuView: View {
    let activitysDiary: [ActivityDiary]?
    @ObservedObject var firebaseManager: FirebaseManager
    
    @Environment(\.dismiss) var dismiss
    
    @State private var type = ["lunch", "breakfast"]
    
    @State private var date = Date()
    @State private var selectedType = 0
    @State private var portion: String = ""
    @State private var mainPlate: String = ""
    @State private var juice: String = ""
    @State private var salad: String = ""
    @State private var fruit: String = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        DatePicker(
                            selection: $date,
                            displayedComponents: .date
                        ) {
                            Text("Date")
                        }
                        
                        Picker("Type", selection: $selectedType) {
                            Text("Lunch").tag(0)
                            Text("Breakfast").tag(1)
                                .foregroundColor(Color.accentColor)
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Portion", text: $portion)
                        TextField("Main Plate", text: $mainPlate)
                        TextField("Fruit", text: $fruit)
                        TextField("Juice", text: $juice)
                        TextField("Salad", text: $salad)
                    }
                }
            }
            .navigationTitle("Create new menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Done") {
                        if portion.isEmpty || mainPlate.isEmpty || fruit.isEmpty || juice.isEmpty || salad.isEmpty {
                            showAlert = true
                        } else {
                            let newFoodMenu = FoodMenu(
                                id: "",
                                title: "dfd",
                                items: [ "portion" : [portion],
                                         "mainPlate" : [mainPlate],
                                         "fruit" : [fruit],
                                         "juice" : [juice],
                                         "salad" : [salad]
                                       ]
                            )
                            
                            Task {
                                do {
                                    let documentID = try await firebaseManager.addFoodMenu(newFoodMenu)
                                    do {
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd/MM/yyyy"
                                        let formattedDate = dateFormatter.string(from: date)
                                        
                                        if let targetActivity = activitysDiary?.first(where: { $0.date == formattedDate }) {
                                            try await firebaseManager.addFoodMenuToDiary(diaryId: targetActivity.id, foodMenuId: documentID)
                                        } else {
                                            try await firebaseManager.addActivityDiary(
                                                ActivityDiary(
                                                    id: "",
                                                    date: formattedDate,
                                                    activityIds: [],
                                                    foodMenuIds: [documentID],
                                                    classId: ""
                                                )
                                            )
                                        }
                                    } catch {
                                        print("Error updating document: \(error)")
                                    }
                                } catch {
                                    print("Error updating document: \(error)")
                                }
                            }
                            
                            dismiss()
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Unfilled Fields!"),
                            message: Text("Please fill in all fields correctly.")
                        )
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showAlert = false
                        dismiss()
                    }
                }
            }
        }
    }
}


func formatType(_ type: Int) -> FoodMenu.Types {
    var result: FoodMenu.Types = .breakfast
    
    if type == 0 {
        result = FoodMenu.Types.lunch
    } else if type == 1 {
        result = FoodMenu.Types.breakfast
    }
    
    return result
}
