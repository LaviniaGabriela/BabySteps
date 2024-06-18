//
//  StudentRecordCardView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct StudentRecordCardView: View {
    let student: Student?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    
                    Image(systemName: "info.square")
                        .font(.title3)
                        .bold()
                    Text("Information")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom)
                
                // name
                VStack(alignment: .leading){
                    Text("NAME")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.name ?? "Error fetching name")
                }
                .padding(.bottom)
                
                // responsible
                VStack(alignment: .leading) {
                    Text("RESPONSIBLES")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.firstResponsible ?? "Error fetching name")
                    Text(student?.secondaryResponsible ?? "Error fetching name")
                }
                .padding(.bottom)
                
                // address
                VStack(alignment: .leading){
                    Text("ADDRESS")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.address ?? "Error")
                }
                .padding(.bottom)
                
                // birthdate
                VStack(alignment: .leading){
                    Text("BIRTH DATE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.birthDate ?? "00/00/0000")
                }
                .padding(.bottom)
                
                // age
                VStack(alignment: .leading){
                    Text("AGE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.age ?? "Error")
                }
                .padding(.bottom)
                
                // main phone
                VStack(alignment: .leading){
                    Text("MAIN PHONE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.mainPhone ?? "Error")
                }
                .padding(.bottom)
                
                
                // secondary phone
                VStack(alignment: .leading){
                    Text("SECONDARY PHONE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.otherPhone ?? "Error")
                }
                .padding(.bottom)
                
                // ingress date
                VStack(alignment: .leading){
                    Text("INGRESS DATE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.ingressDate ?? "00/00/0000")
                }
                .padding(.bottom)
                
            }
            
            Spacer()
        }.padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            }
    }
    
    private func formattedDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
    }
}

//struct StudentRecordCardView_Previews: PreviewProvider {
//    @State var student = Student(
//        id: UUID(),
//        name: "João Gabriel",
//        responsible: ["Mariana Gabriel", "Henrique da Silva"],
//        address: "123 Main Street, City",
//        bornDate: Date(),
//        age: "18",
//        mainPhone: "123-456-7890",
//        otherPhone: "987-654-3210",
//        ingressDate: Date(),
//        foodRestrictions: ["No nuts", "Gluten-free"],
//        allergies: ["Pollen", "Cats"],
//        bloodType: "A+",
//        preferredHospital: "City General Hospital",
//        missingVacines: ["Flu", "HPV"],
//        studentPhoto: Image("foto-criança"),
//        studentDiary: [Date() : Diary(date: Date(),
//                                      water: Diary.DiaryReport(satisfaction: .half, observation: "Drank less water"),
//                                      milk: Diary.DiaryReport(satisfaction: .few, observation: "Skipped milk today"),
//                                      fruit: Diary.DiaryReport(satisfaction: .didNotAccept, observation: "No fruits today"),
//                                      lunch: Diary.DiaryReport(satisfaction: .atHome, observation: "Ate lunch at home"),
//                                      snackTime: Diary.DiaryReport(satisfaction: .all, observation: ""),
//                                      attendance: false,
//                                      attendanceObservation: "Missed morning class",
//                                      completed: true)],
//        studentClass: UUID()
//    )
//
//    static var previews: some View {
//        StudentRecordCardView(student: $student)
//    }
//}
