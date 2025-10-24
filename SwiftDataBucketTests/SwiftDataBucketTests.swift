//
//  SwiftDataBucketTests.swift
//  SwiftDataBucketTests
//
//  Created by Alumno on 24/10/25.
//

import Testing
@testable import CRUD


struct SwiftDataBucketTests {

    @Test("Task name must not be empty or whitespace only")
    func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(Task.isValidName("task"))
        #expect(!Task.isValidName(""))
        #expect(!Task.isValidName(" "))
    }
    
    @Test("Category icon must match expected system image")
        func testCategoryIconMatch() async throws {
            #expect(TaskCategory.icon(for: .work) == "briefcase.fill")
            #expect(TaskCategory.icon(for: .personal) == "person.fill")
            #expect(TaskCategory.icon(for: .shopping) == "cart.fill")
            #expect(TaskCategory.icon(for: .health) == "heart.fill")
        }

}
