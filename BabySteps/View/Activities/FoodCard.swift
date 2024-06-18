//
//  FoodCard.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

func foodCard(title: String, description: [String]) -> some View {
    VStack {
        HStack {
            Text(title).font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray).textCase(.uppercase)
            Spacer()
        }
        ForEach(description, id: \.self) { item in
            HStack {
                Text(item).font(.system(size: 17, weight: .regular))
                Spacer()
            }
        }
    }
}
