//
//  TaskAppView.swift
//  TCA-ToDoList
//
//  Created by Merouane Bellaha on 29/09/2020.
//

import SwiftUI
import Combine
import ComposableArchitecture

// MARK: - State

struct AppState: Equatable {
    var tasks: [Task] = []
}

// MARK: - Action

enum AppAction: Equatable {
    case todo(index: Int, action: TaskAction)
    case addButtonTapped
    case taskDelayCompleted
}

// MARK: - Environment
// holds the dependencies

struct AppEnvironment {
    var uuid: () -> UUID

    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Reducer
// glues state, action and environment into a cohesive package
// responsible for the business logic that runs the app

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    taskReducer.forEach(
        state: \.tasks,
        action: /AppAction.todo,
        environment: { _ in TaskEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        
        case .todo(index: _, action: .checkboxTapped):
            struct CancelDelayID: Hashable {}
            return Effect(value: AppAction.taskDelayCompleted)
                .debounce(id: CancelDelayID(), for: 1, scheduler: environment.mainQueue)

        case .todo(index: _, action: .textFieldChanged):
            return .none

        case .addButtonTapped:
            state.tasks.insert(Task(id: environment.uuid()), at: 0)
            return .none

        case .taskDelayCompleted:
            state.tasks = state.tasks
                .enumerated()
                .sorted { lhs, rhs in
                    (!lhs.element.isComplete && rhs.element.isComplete)
                        || lhs.offset < rhs.offset
                }
                .map(\.element)
            return .none
        }
    }
)
.debug()

struct TaskAppView: View {

    // MARK: - Store

    let store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEachStore(
                        store.scope(
                            state: \.tasks,
                            action: AppAction.todo
                        ),
                        content: TaskView.init(store:)
                    )
                }
                .navigationTitle("Tasks")
                .navigationBarItems(trailing: Button("add") {
                    viewStore.send(.addButtonTapped)
                })

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskAppView(
            store: Store(
                initialState: AppState(
                    tasks: [
                        Task(
                            description: "do something",
                            id: UUID(),
                            isComplete: false
                        ),
                        Task(
                            description: "do something else",
                            id: UUID(),
                            isComplete: false
                        ),
                        Task(
                            description: "something more",
                            id: UUID(),
                            isComplete: true
                        )
                    ]
                ),
                reducer: appReducer,
                environment: AppEnvironment(
                    uuid: UUID.init,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
