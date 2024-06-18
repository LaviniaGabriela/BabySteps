//
//  StudentHealthCardView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct StudentHealthCardView: View {
    let student: Student?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    
                    Image(systemName: "heart.square")
                        .font(.title3)
                        .bold()
                    Text("Health Data")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom)
                
                // food restrictions
                VStack(alignment: .leading){
                    Text("FOOD RESTRICTIONS")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    ForEach(student?.foodRestrictions ?? [], id:\.self) { restriction in
                        Text(restriction)
                    }
                }
                .padding(.bottom)
                
                // allergies
                VStack(alignment: .leading) {
                    Text("ALLERGIES")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    
                    ForEach(student?.allergies ?? [], id:\.self) { allergy in
                        Text(allergy)
                    }
                }
                .padding(.bottom)
                
                // blood type
                VStack(alignment: .leading){
                    Text("BLOOD TYPE")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.bloodType ?? "Not available")
                }
                .padding(.bottom)
            
                
                // preferred hospital
                VStack(alignment: .leading){
                    Text("PREFERRED HOSPITAL")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.preferredHospital ?? "Not available")
                }
                .padding(.bottom)
                
                // missing vaccines
                VStack(alignment: .leading){
                    Text("MISSING VACCINES")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    ForEach(student?.missingVaccines ?? [], id:\.self) { vaccine in
                        Text(vaccine)
                    }
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
}

//struct StudentHealthCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentHealthCardView(student: Student(
//            id: UUID(),
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
