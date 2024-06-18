//
//  Student.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation

struct Student: Identifiable, Hashable {
    var id: String = ""
    var name: String
    var gender: String
    var address: String
    var birthDate: String
    var age: String
    var mainPhone: String
    var otherPhone: String
    var ingressDate: String
    var foodRestrictions: [String]
    var allergies: [String]
    var bloodType: String
    var preferredHospital: String
    var missingVaccines: [String]
    var studentPhoto: String
    var studentClass: String
    var firstResponsible: String
    var secondaryResponsible: String
    var selected: Bool = false
    var email: String
    var password: String
    var announcements: [String] = []
    var parentID: String
    var schoolID: String

}
