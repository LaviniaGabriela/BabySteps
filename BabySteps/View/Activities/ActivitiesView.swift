//
//  ActivitiesView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct ActivitiesView: View {
    @State var activitysDiary: [ActivityDiary]? = nil
    @State var foodMenu: [FoodMenu] = []
    @State var activities: [Activity] = []
    @State private var activitiesAvailable = false
    @State private var date = Calendar.current.startOfDay(for: Date())
    @State private var shouldShowMenu = false
    @State private var isCreateNewMenuViewPresented = false
    
    @ObservedObject var firebaseManager: FirebaseManager
    
    @State private var isDetailViewPresented = false
    @State private var detailsInfo = (title: "", description: "", image: "")
    @State private var showDatePicker = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "F3F3F8"), Color(hex: "ECECF9")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                    
                    Text(date.formatDate())
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
                
                if (activitysDiary != nil && activitiesAvailable) {
                    ScrollView {
                        HStack {
                            Text("Menu").font(.system(size: 22, weight: .bold))
                                .padding(.bottom, 16)
                            Spacer()
                        }
                        if (!foodMenu.isEmpty) {
                            HStack {
                                ForEach(foodMenu, id: \.id) { item in
                                    VStack {
                                        HStack {
                                            Text(item.title).font(.system(size: 20, weight: .semibold))
                                            Spacer()
                                        }
                                        LazyVGrid(columns: columns, spacing: 16) {
                                            ForEach(item.items.keys.sorted(), id: \.self) { foodKey in
                                                if let foodValue = item.items[foodKey] {
                                                    foodCard(title: foodKey, description: foodValue)
                                                }
                                            }
                                        }
                                    }.padding(16)
                                        .background(.white)
                                        .cornerRadius(10)
                                }
                            }
                            Spacer()
                        } else {
                            Text("No food menu records found.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        if (!activities.isEmpty) {
                            HStack {
                                Text("Activities").font(.system(size: 22, weight: .bold))
                                    .padding(.bottom, 16)
                                Spacer()
                            }.padding(.top, 16)
                            
                            ForEach(activities, id: \.id) { activityItem in
                                activityCard(title: activityItem.title, description: activityItem.description,
                                             image: activityItem.image,
                                             action: {
                                    isDetailViewPresented = true
                                    detailsInfo = (title: activityItem.title, description: activityItem.description, image: activityItem.image)
                                }
                                )
                            }
                            Spacer()
                            
                        } else {
                            Text("No activites records found.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding()
                            Spacer()
                        }
                    }.scrollIndicators(ScrollIndicatorVisibility.hidden)
                } else {
                    Text("No activites diary records found.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }.padding(16)
            .navigationTitle("Mural")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                isCreateNewMenuViewPresented.toggle()
                            }) {
                                Label("Create new menu", systemImage: "menucard")
                            }
                            Button(action: {
                                
                            }) {
                                Label("Create new activity", systemImage: "dice")
                            }
                        } label: {
                            Label("", systemImage: "plus")
                        }
                        
                    
                }
            }.sheet(isPresented: $isCreateNewMenuViewPresented) {
                CreateNewMenuView(
                    activitysDiary: activitysDiary, firebaseManager: firebaseManager
                )
            }

                
                .sheet(isPresented: $isDetailViewPresented) {
                    ActivitysDetailSheetView(title: detailsInfo.title, description: detailsInfo.description, image: detailsInfo.image)
                }
                        
            if showDatePicker {
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
                            activitiesAvailable = false
                            
                            activities = []
                            foodMenu = []
                            activitysDiary = nil
                            
                            firebaseManager.fetchActicitiesDiary() { fetchedActivity, error in
                                if let error = error {
                                    activitiesAvailable = false
                                    print("Error fetching diary activities entries: \(error)")
                                } else if let fetchedActivity = fetchedActivity {
                                    activitysDiary = fetchedActivity
                                    activitiesAvailable = true
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd/MM/yyyy"
                                    
                                    let formattedDate = dateFormatter.string(from: date)
                                    
                                    if let targetActivity = activitysDiary?.first(where: { $0.date == formattedDate }) {
                                        for menuItemId in targetActivity.foodMenuIds {
                                            firebaseManager.fetchFoodMenus(foodMenuId: menuItemId) { fetchedMenu, error in
                                                if let error = error {
                                                    activitiesAvailable = false
                                                    print("Error fetching menu entries: \(error)")
                                                } else if let fetchedMenu = fetchedMenu {
                                                    withAnimation(.spring()) {
                                                        foodMenu = []
                                                        foodMenu.append(fetchedMenu)
                                                        activitiesAvailable = true
                                                    }
                                                }
                                            }
                                        }
                                        
                                        for activityItemId in targetActivity.activityIds {
                                            firebaseManager.fetchActivity(id: activityItemId){ fetchedActivity, error in
                                                if let error = error {
                                                    activitiesAvailable = false
                                                    print("Error fetching activity entries: \(error)")
                                                } else if let fetchedActivity = fetchedActivity {
                                                    withAnimation(.spring()) {
                                                        activities = []
                                                        activities.append(fetchedActivity)
                                                        activitiesAvailable = true
                                                    }
                                                }
                                            }
                                        }
                                    }
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
            
        }.onAppear {
            showDatePicker = false
            activitiesAvailable = false
            
            firebaseManager.fetchActicitiesDiary() { fetchedActivity, error in
                if let error = error {
                    activitiesAvailable = false
                    print("Error fetching diary activities entries: \(error)")
                } else if let fetchedActivity = fetchedActivity {
                    activitysDiary = fetchedActivity
                    activitiesAvailable = true
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    
                    let formattedDate = dateFormatter.string(from: date)
                    
                    if let targetActivity = activitysDiary?.first(where: { $0.date == formattedDate }) {
                        for menuItemId in targetActivity.foodMenuIds {
                            firebaseManager.fetchFoodMenus(foodMenuId: menuItemId) { fetchedMenu, error in
                                if let error = error {
                                    activitiesAvailable = false
                                    print("Error fetching menu entries: \(error)")
                                } else if let fetchedMenu = fetchedMenu {
                                    withAnimation(.spring()) {
                                        foodMenu = []
                                        foodMenu.append(fetchedMenu)
                                        activitiesAvailable = true
                                    }
                                }
                            }
                        }
                        
                        for activityItemId in targetActivity.activityIds {
                            firebaseManager.fetchActivity(id: activityItemId){ fetchedActivity, error in
                                if let error = error {
                                    activitiesAvailable = false
                                    print("Error fetching activity entries: \(error)")
                                } else if let fetchedActivity = fetchedActivity {
                                    withAnimation(.spring()) {
                                        activities = []
                                        activities.append(fetchedActivity)
                                        activitiesAvailable = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
