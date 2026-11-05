//
//  apple_lab12_pract03_SwiftDataApp.swift
//  apple_lab12_pract03_SwiftData
//
//  Created by Jaime Gomez on 1/6/25.
//

import SwiftUI
import SwiftData

@main
struct apple_lab12_pract03_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Teacher.self)
    }
}
