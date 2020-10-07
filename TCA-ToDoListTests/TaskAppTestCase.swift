//
//  TaskAppTestCase.swift
//  TCA-ToDoListTests
//
//  Created by Merouane Bellaha on 05/10/2020.
//

import ComposableArchitecture
import XCTest
@testable import TCA_ToDoList

class TaskAppTestCase: XCTestCase {

    func testCompletingTask() {
        let store = TestStore(
            initialState: AppState(
                tasks: [
                    Task(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError("Unimplemented") }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.tasks[0].isComplete = true
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
            },
            .receive(.taskDelayCompleted)
        )
    }

    func testAddTask() {
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { UUID(uuidString: "00000000-0000-0000-0000-000000000000")!}
            )
        )

        store.assert(
            .send(.addButtonTapped) {
                $0.tasks = [
                    Task(
                        description: "",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    )
                ]
            }
        )
    }

    func testTaskSorting() {
        let store = TestStore(
            initialState: AppState(
                tasks: [
                    Task(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    ),
                    Task(
                        description: "Eggs",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError("Unimplemented") }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.tasks[0].isComplete = true
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
            },
            .receive(.taskDelayCompleted) {
                $0.tasks = [
                    Task(
                        description: "Eggs",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        isComplete: false
                    ),
                    Task(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: true
                    )
                ]
            }
        )
    }

    func testTaskSorting_Cancellation() {
        let store = TestStore(
            initialState: AppState(
                tasks: [
                    Task(
                        description: "Milk",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                        isComplete: false
                    ),
                    Task(
                        description: "Eggs",
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        isComplete: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { fatalError("Unimplemented") }
            )
        )

        store.assert(
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.tasks[0].isComplete = true
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 0.5)
            },
            .send(.todo(index: 0, action: .checkboxTapped)) {
                $0.tasks[0].isComplete = false
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
            },
            .receive(.taskDelayCompleted)
//                {
//                $0.tasks = [
//                    Task(
//                        description: "Milk",
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
//                        isComplete: true
//                    ),
//                    Task(
//                        description: "Eggs",
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
//                        isComplete: true
//                    )
//                ]
//            }
        )
    }


}



