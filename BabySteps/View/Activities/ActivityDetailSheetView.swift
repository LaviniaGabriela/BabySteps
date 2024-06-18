//
//  ActivityDetailSheetView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

func ActivitysDetailSheetView(title: String, description: String, image: String) -> some View {
    HStack {
        VStack(alignment: .leading) {
            ScrollView {
                Text(title).font(.system(size: 20, weight: .semibold))
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fill)
                .frame(height: 280)
                .cornerRadius(16)
                Text(description).font(.system(size: 17, weight: .regular)).padding(.top, 16)
                Spacer()
            }.scrollIndicators(ScrollIndicatorVisibility.hidden)
        }
        Spacer()
    }.padding(24)
}
