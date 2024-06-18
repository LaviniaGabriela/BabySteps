//
//  OnboardingView.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userManager: UserManager
    @Binding var finishedOnboarding: Bool
    @State var pickerSelection = 0
    @State var onboardingStage = 0
    @State var rectangleAnimationAux = 0
    
    var body: some View {
        ZStack {
            // rectangles
            ZStack {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.accentColor).opacity(0.5)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.accentColor).opacity(0.05)
                        }
                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                        .rotationEffect(Angle(degrees: rectangleAnimationAux == 0 ? 24 : 45))
                        .position(x: geo.size.width - 120, y: geo.size.height + 60)
                    
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color(hex: "7C84FF")).opacity(0.5)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(hex: "7C84FF")).opacity(0.05)
                        }
                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                        .rotationEffect(Angle(degrees: rectangleAnimationAux == 0 ? -7 : -15))
                        .position(x: geo.size.width + 40, y: geo.size.height - 80)
                    
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.accentColor).opacity(0.5)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.accentColor).opacity(0.05)
                        }
                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                        .rotationEffect(Angle(degrees: rectangleAnimationAux == 0 ? -40 : -15))
                        .position(x: 0, y: 160)
                    
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color(hex: "7C84FF")).opacity(0.5)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color(hex: "7C84FF")).opacity(0.05)
                        }
                        .frame(width: geo.size.width / 4, height: geo.size.width / 4)
                        .rotationEffect(Angle(degrees: rectangleAnimationAux == 0 ? -15 : 0))
                        .position(x: 100, y: -40)
                }
                
                
                
            }
                
            if onboardingStage == 0 {
                VStack {
                    Text("Welcome to Childly")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 32)
                    
                    Text("Enter the system as:")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    CustomPicker(selection: $pickerSelection)
                        .frame(width: 250)
                        .padding(.bottom, 32)
                    
                    if pickerSelection == 0 {
                        Text("Track students, log activities, add events and\n communicate with parents, all in one place!")
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text("Track your child's activities, school events and easily\n communicate through the chat, all in one place!")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    
                    Text("(You can always change this later)")
                        .font(.callout)
                        .padding(.bottom, 32)
                    
                    Button("Next") {
                        withAnimation(.spring()) {
                            onboardingStage = 1
                        }
                        withAnimation(.spring(dampingFraction: 3, blendDuration: 300)) {
                            rectangleAnimationAux = 1
                        }
                        
                        if pickerSelection == 0 {
                            UserDefaults.standard.set("School", forKey: "UserType")
                            userManager.userType = "School"
                        } else {
                            UserDefaults.standard.set("Parent", forKey: "UserType")
                            userManager.userType = "Parent"
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 64)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentColor)
                    }
                    .padding()
                }
            } else {
                VStack {
                    Text("Our Main Features")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 32)
                    
                    if UIDevice.current.userInterfaceIdiom == .pad { // iPad
                        HStack(alignment: .top) {
                            VStack {
                                Image("DiaryAct")
                                
                                Text("Simplified\nManagement")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("Organize classes, students,\nand relevant information in\nan intuitive manner.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            
                            VStack {
                                Image("ListIcon")
                                
                                Text("Activities\nDiary")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("Record daily activities and\nshare updates.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            VStack {
                                Image("CalendarIcon")
                                
                                Text("Events and\nMeetings")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("Effortlessly plan important\nevents and meetings.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                    } else { // iPhone
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("Simplified Management")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top)
                                    .padding(.bottom, 4)
                                
                                Text("Organize classes, students, and relevant information in\nan intuitive manner.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                            
                            
                            VStack(alignment: .leading) {
                                Text("Activities Diary")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top)
                                    .padding(.bottom, 4)
                                
                                Text("Record daily activities and share updates.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Events and Meetings")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top)
                                    .padding(.bottom, 4)
                                
                                Text("Effortlessly plan important events and meetings.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                        }
                    }
                    
                    
                    
                    Text("(You can always change this later)")
                        .font(.callout)
                        .padding(.top)
                        .padding(.bottom, 32)
                    
                    HStack {
                        Button("Return") {
                            withAnimation(.spring()) {
                                onboardingStage = 0
                            }
                            withAnimation(.spring(dampingFraction: 3, blendDuration: 300)) {
                                rectangleAnimationAux = 0
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.horizontal, 24)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray).opacity(0.35)
                        }
                        Button("Start Now") {
                            withAnimation(.spring()) {
                                finishedOnboarding = true
                            }
                            
                            UserDefaults.standard.set(true, forKey: "Onboarding")
                           
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 64)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor)
                        }
                    }
                    
                    .padding()
                }
            }
            
        }
        
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    
    static var previews: some View {
        OnboardingView(finishedOnboarding: .constant(false))
            .environmentObject(UserManager())
    }
}

