//
//  Teacher.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Jeferson Huittoccollo on 05/11/26.
//

import Foundation
import SwiftData

@Model
final class Teacher {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var dateOfBirth: Date
    var specialty: String
    var hireDate: Date
    var isActive: Bool
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    init(
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        phone: String = "",
        dateOfBirth: Date = Date(),
        specialty: String = "",
        hireDate: Date = Date(),
        isActive: Bool = true
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.dateOfBirth = dateOfBirth
        self.specialty = specialty
        self.hireDate = hireDate
        self.isActive = isActive
    }
}
