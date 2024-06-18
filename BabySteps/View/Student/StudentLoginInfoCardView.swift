//
//  StudentLoginInfoCardView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct StudentLoginInfoCardView: View {
    let student: Student?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    
                    Image(systemName: "info.square")
                        .font(.title3)
                        .bold()
                    Text("Login Info")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom)
                
                // email
                VStack(alignment: .leading){
                    Text("EMAIL")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.email ?? "Error fetching email")
                }
                .padding(.bottom)
                
                // password
                VStack(alignment: .leading) {
                    Text("PASSWORD")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Text(student?.password ?? "Error fetching password")
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

//struct StudentLoginInfoCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudentLoginInfoCardView()
//    }
//}
