//
//  ContentView.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Jaime Gomez on 1/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var searchText = ""
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            TeacherListView(searchText: searchText)
                .navigationTitle("Docentes")
                .searchable(text: $searchText, prompt: "Buscar por nombre, especialidad...")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.indigo)
                        }
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    NavigationStack {
                        AddEditTeacherView(teacher: nil)
                    }
                }
        }
    }
}

struct TeacherListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var teachers: [Teacher]
    
    init(searchText: String) {
        let predicate = #Predicate<Teacher> { teacher in
            if searchText.isEmpty {
                return true
            } else {
                return teacher.firstName.localizedStandardContains(searchText) ||
                       teacher.lastName.localizedStandardContains(searchText) ||
                       teacher.specialty.localizedStandardContains(searchText) ||
                       teacher.email.localizedStandardContains(searchText)
            }
        }
        _teachers = Query(filter: predicate, sort: \Teacher.lastName)
    }
    
    var body: some View {
        Group {
            if teachers.isEmpty {
                ContentUnavailableView(
                    "No hay docentes registrados",
                    systemImage: "person.slash",
                    description: Text("Presiona el botón '+' para agregar un nuevo docente.")
                )
            } else {
                List {
                    ForEach(teachers) { teacher in
                        NavigationLink(destination: AddEditTeacherView(teacher: teacher)) {
                            TeacherCardView(teacher: teacher)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteTeachers)
                }
                .listStyle(.plain)
            }
        }
    }
    
    private func deleteTeachers(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(teachers[index])
        }
    }
}

struct TeacherCardView: View {
    let teacher: Teacher
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar con iniciales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: teacher.isActive ? [.indigo, .blue] : [.gray, .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(teacher.initials)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            // Información principal
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(teacher.fullName.isEmpty ? "Sin Nombre" : teacher.fullName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    // Badge Activo / Inactivo
                    Text(teacher.isActive ? "Activo" : "Inactivo")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(teacher.isActive ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .foregroundStyle(teacher.isActive ? Color.green : Color.red)
                        .clipShape(Capsule())
                }
                
                if !teacher.specialty.isEmpty {
                    Label(teacher.specialty, systemImage: "briefcase.fill")
                        .font(.subheadline)
                        .foregroundStyle(.indigo)
                }
                
                if !teacher.email.isEmpty {
                    Label(teacher.email, systemImage: "envelope.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}
