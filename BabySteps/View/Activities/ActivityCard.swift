//
//  ActivityCard.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

func activityCard(title: String, description: String, image: String, action: @escaping () -> Void) -> some View {
    HStack {
        VStack(alignment: .leading) {
            Text(title).font(.system(size: 20, weight: .semibold))
            HStack {
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 180, height: 140)
                .cornerRadius(16)
                VStack (alignment: .leading) {
                    Text(description).font(.system(size: 17, weight: .regular)).lineLimit(4)
                    
                    Button(action: action) {
                        Text("Read more...")
                            .foregroundColor(Color(hex: "FA8072"))
                            .font(.body)
                            .padding(.top, 16)
                    }
                }
            }
        }
        Spacer()
    }.padding(16)
        .background(.white)
        .cornerRadius(10)
}
