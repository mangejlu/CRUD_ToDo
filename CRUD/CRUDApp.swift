//
//  CRUDApp.swift
//  CRUD
//
//  Created by Alumno on 22/10/25.
//

import SwiftUI
import SwiftData

@main
struct CRUDapp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Task.self])
    }
}
