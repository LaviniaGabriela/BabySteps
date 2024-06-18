//
//  AddNewMuralView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct AddNewMuralView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var firebaseManager: FirebaseManager
    @EnvironmentObject var user: UserManager

    @State var allAnnouncement: [Announcement] = []

    @State private var types = ["meetings", "events"]
    
    /// @State var announcement = Announcement(id: "", title: "", description: "", photo: "", dateEvent: "", writerName: "", type: Announcement.Types.events)
    
    @State private var title: String = ""
    @State private var selectedDefaultPickerItem = 0
    @State private var dateChosen = Date()
    @State private var writerName: String = ""
    @State private var description: String = ""
    @FocusState private var fieldIsFocused: Bool
    @State private var showAlert = false
    @Binding var shouldFetchData: Bool
    
    var body: some View {
        if user.userAuthID == "" {
            ProfileView()
        } else {
            NavigationStack {
                VStack {
                    Form {
                        //TODO: PhotoPicker - make a photopicker and send this image to cloud storage on firebase
                        
                        //                    Section {
                        //                        VStack (alignment: .center){
                        //                            Image("foto-criança")
                        //                                .resizable()
                        //                                .frame(width: 140, height: 140)
                        //                                .cornerRadius(20)
                        //                            Text(" Choose photo ")
                        //                                .font(.body)
                        //                                .foregroundColor(.accentColor)
                        //                                .background(Color.clear)
                        //                        }
                        //                        .frame(maxWidth: .infinity, alignment: .center)
                        //
                        //                    }
                        //                    .listRowBackground(Color.clear)
                        
                        Section {
                            TextField("Title", text: $title)
                                .focused($fieldIsFocused)
                        }
                        
                        Section {
                            Picker("Type", selection: $selectedDefaultPickerItem) {
                                Text("Meeting").tag(0)
                                Text("Event").tag(1)
                                    .foregroundColor(Color.accentColor)
                            }
                            // .pickerStyle(DefaultPickerStyle())
                            .pickerStyle(.menu)
                            
                            
                            DatePicker(
                                selection: $dateChosen,
                                displayedComponents: .date
                            ) {
                                Text("Date")
                            }
                        }
                        
                        Section {
                            TextField("Writer name", text: $writerName)
                                .focused($fieldIsFocused)
                        }
                        
                        Section {
                            //                        ZStack(alignment: .topLeading) {
                            //                            if description.isEmpty {
                            //                                Text("Description")
                            //                                    .foregroundColor(.placeholderText)
                            //                                    .padding(.horizontal, 4)
                            //                                    .padding(.top, 8)
                            //                            }
                            //
                            //                            TextEditor(text: $description)
                            //                                .frame(height: 200)
                            //                        }
                            CustomTextEditor(text: $description, placeholder: "Description", placeholderColor:
                                                Color(UIColor.placeholderText))
                            .focused($fieldIsFocused)
                        }
                    }
                }
                .navigationTitle("Create new meeting or event")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            
                            fieldIsFocused = false
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button ("OK"){
                            if description.isEmpty || writerName.isEmpty || title.isEmpty {
                                
                                showAlert = true
                                
                                fieldIsFocused = true
                                
                                
                            } else {
                                var newAnnouncement = Announcement(
                                    id: "",
                                    title: title.trimmingCharacters(in: .whitespaces),
                                    description: description .trimmingCharacters(in: .whitespaces),
                                    photo: "https://www.ufrgs.br/renafor/wp-content/uploads/2015/05/fundo-cinza.jpg",
                                    dateEvent: formatDate(dateChosen),
                                    writerName: writerName.trimmingCharacters(in: .whitespaces),
                                    type: formatType(selectedDefaultPickerItem)
                                )
                                
                                // MARK: FEATURE - Change the mode of send to the firebase, now we have to do this by each user
                                
                                Task {
                                    do {
                                        let documentID = try await firebaseManager.addAnnouncement(newAnnouncement)
                                                                                
                                        var userID = user.userID
                                                                                
                                        do {
                                            for studentID in user.students {
                                                try await firebaseManager.addAnnouncementToStudent(announcementID: documentID, studentID: studentID)
                                                try await firebaseManager.addAnnouncementToUser(announcementID: documentID, userID: user.userID)
                                            }
                                            
                                            user.announcements.append(documentID)
                                        } catch {
                                            print("Error updating document: \(error)")
                                        }
                                        
                                    } catch {
                                        print("Error")
                                    }
                                }
                                
                                shouldFetchData.toggle()
                            
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Unfilled Fields!"),
                                message: Text("Please fill in all fields correctly.")
                            )
                        }
                        
                    }
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM d"
        
        return dateFormatter.string(from: date)
    }
    
    func formatType(_ type: Int) -> Announcement.Types {
        var result: Announcement.Types = .events
        
        if type == 0 {
            result = Announcement.Types.meetings
        } else if type == 1 {
            result = Announcement.Types.events
        }
        
        return result
    }
}

struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .padding(.horizontal, 2)
                    .padding(.top, 8)
            }
            
            TextEditor(text: $text)
                .frame(height: 200)
        }
    }
}

//
//struct AddNewMuralView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewMuralView()
//    }
//}
