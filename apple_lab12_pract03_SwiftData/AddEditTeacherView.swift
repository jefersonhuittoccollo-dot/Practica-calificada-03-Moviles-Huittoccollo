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
    
    var currentInitials: String {
        let f = firstName.prefix(1)
        let l = lastName.prefix(1)
        let res = "\(f)\(l)".uppercased()
        return res.isEmpty ? "?" : res
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
            // Header con Avatar en vivo
            Section {
                VStack(spacing: 8) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isActive ? [.indigo, .blue] : [.gray, .secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .overlay(
                            Text(currentInitials)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                        .shadow(color: .indigo.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Text(firstName.isEmpty && lastName.isEmpty ? "Nuevo Docente" : "\(firstName) \(lastName)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
            
            // Sección Personal
            Section(header: Label("Información Personal", systemImage: "person.fill").foregroundStyle(.indigo)) {
                TextField("Nombres", text: $firstName)
                TextField("Apellidos", text: $lastName)
                
                HStack {
                    Image(systemName: "envelope.fill").foregroundStyle(.gray)
                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                
                HStack {
                    Image(systemName: "phone.fill").foregroundStyle(.gray)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                DatePicker("Fecha de Nacimiento", selection: $dateOfBirth, displayedComponents: .date)
            }
            
            // Sección Profesional
            Section(header: Label("Información Profesional", systemImage: "briefcase.fill").foregroundStyle(.indigo)) {
                HStack {
                    Image(systemName: "academicons.fill").foregroundStyle(.gray)
                    TextField("Especialidad (ej. Java Senior)", text: $specialty)
                }
                DatePicker("Fecha de Contratación", selection: $hireDate, displayedComponents: .date)
                Toggle("Estado Activo", isOn: $isActive)
                    .tint(.indigo)
            }
            
            // Opción de Eliminar si está editando
            if isEditing {
                Section {
                    Button(role: .destructive) {
                        if let teacher = teacher {
                            modelContext.delete(teacher)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Eliminar Docente", systemImage: "trash.fill")
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Editar Docente" : "Nuevo Docente")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    saveTeacher()
                    dismiss()
                }
                .bold()
                .foregroundStyle(.indigo)
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
