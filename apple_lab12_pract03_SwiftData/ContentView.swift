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
                .navigationTitle("Teachers")
                .searchable(text: $searchText, prompt: "Search teachers...")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
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
                       teacher.email.localizedStandardContains(searchText)
            }
        }
        _teachers = Query(filter: predicate, sort: \Teacher.lastName)
    }
    
    var body: some View {
        List {
            ForEach(teachers) { teacher in
                NavigationLink(destination: AddEditTeacherView(teacher: teacher)) {
                    TeacherRowView(teacher: teacher)
                }
            }
            .onDelete(perform: deleteTeachers)
        }
    }
    
    private func deleteTeachers(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(teachers[index])
        }
    }
}

struct TeacherRowView: View {
    let teacher: Teacher
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(teacher.fullName)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(teacher.specialty)
                .font(.subheadline)
                .foregroundStyle(.blue)
            
            Text(teacher.email)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 2)
    }
}
