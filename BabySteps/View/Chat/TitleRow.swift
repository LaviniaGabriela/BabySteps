//
//  TitleRow.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct TitleRow: View {
    var imageURL = URL(string: "https://avatars.githubusercontent.com/u/142418622?s=400&v=4")
    
    var name = "Development Team"
    
    var body: some View {
        HStack (spacing: 20) {
//            AsyncImage(url: imageURL) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(50)
//            } placeholder: {
//                ProgressView()
//            }
            
            VStack (alignment: .leading) {
                Text(name)
                    .font(.title)
                    .bold()
                
                Text("Online")
                    .font(.body)
                    .foregroundColor(Color(hex: "7C84FF"))
                    .bold()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
//            Image(systemName: "phone.fill")
//                .foregroundColor(.green)
//                .padding(10)
//                .background(.white)
//                .cornerRadius(50)
        }
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(Color("AccentColor"))
    }
}
