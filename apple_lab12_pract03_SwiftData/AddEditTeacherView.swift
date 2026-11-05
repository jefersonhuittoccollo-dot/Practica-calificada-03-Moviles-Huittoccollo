//
//  AddEditTeacherView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Jeferson Huittoccollo on 05/11/26.
//

import SwiftUI
import SwiftData

struct AddEditTeacherView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let teacher: Teacher?
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var specialty: String = ""
    @State private var hireDate: Date = Date()
    @State private var isActive: Bool = true
    
    var isEditing: Bool {
        teacher != nil
    }
    
    init(teacher: Teacher? = nil) {
        self.teacher = teacher
        _firstName = State(initialValue: teacher?.firstName ?? "")
        _lastName = State(initialValue: teacher?.lastName ?? "")
        _email = State(initialValue: teacher?.email ?? "")
        _phone = State(initialValue: teacher?.phone ?? "")
        _dateOfBirth = State(initialValue: teacher?.dateOfBirth ?? Date())
        _specialty = State(initialValue: teacher?.specialty ?? "")
        _hireDate = State(initialValue: teacher?.hireDate ?? Date())
        _isActive = State(initialValue: teacher?.isActive ?? true)
    }
    
    var body: some View {
        Form {
            Section(header: Text("PERSONAL INFORMATION")) {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
            }
            
            Section(header: Text("PROFESSIONAL INFORMATION")) {
                TextField("Specialty", text: $specialty)
                DatePicker("Hire Date", selection: $hireDate, displayedComponents: .date)
                Toggle("Active", isOn: $isActive)
            }
            
            if isEditing {
                Section {
                    Button(role: .destructive) {
                        if let teacher = teacher {
                            modelContext.delete(teacher)
                        }
                        dismiss()
                    } label: {
                        Text("Delete Teacher")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Teacher" : "Add Teacher")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveTeacher()
                    dismiss()
                }
            }
        }
    }
    
    private func saveTeacher() {
        if let teacher = teacher {
            teacher.firstName = firstName
            teacher.lastName = lastName
            teacher.email = email
            teacher.phone = phone
            teacher.dateOfBirth = dateOfBirth
            teacher.specialty = specialty
            teacher.hireDate = hireDate
            teacher.isActive = isActive
        } else {
            let newTeacher = Teacher(
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                dateOfBirth: dateOfBirth,
                specialty: specialty,
                hireDate: hireDate,
                isActive: isActive
            )
            modelContext.insert(newTeacher)
        }
    }
}
