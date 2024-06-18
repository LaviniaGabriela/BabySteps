//
//  Message.swift
//  BabySteps
//
//  Created by Lavinia Gabriela on 18/06/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var sender: String
    var receiver: String
    var timestamp: Date
}
