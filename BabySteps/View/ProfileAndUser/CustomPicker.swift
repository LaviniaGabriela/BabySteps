//
//  CustomPicker.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct CustomPicker: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    @State var selectionAux: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    if selectionAux == 0 {
                        Text("School")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        Text("School")
                            .font(.headline)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .padding()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectionAux = 0
                }
                withAnimation(.spring()) {
                    selection = 0
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .center) {
                    if selectionAux == 1 {
                        Text("Parent")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()

                    } else {
                        Text("Parent")
                            .font(.headline)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .padding()
                    }

                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .onAppear {
                selectionAux = selection
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectionAux = 1
                }
                withAnimation(.spring()) {
                    selection = 1
                }
            }
        }
        .frame(height: 48)
        .background {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(.gray)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(colorScheme == .dark ? .black : .white))
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("AccentColor"))
                        .frame(width: geo.size.width / 2, height: geo.size.height)
                        .padding(.leading, selectionAux == 0 ? 0 : geo.size.width / 2)
                }
            }
            
            
        }
    }
}

//struct CustomPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPicker()
//    }
//}
