//
//  ContentView.swift
//  TCA-ToDoList
//
//  Created by Merouane Bellaha on 29/09/2020.
//

import SwiftUI
import ComposableArchitecture


struct Task: Equatable, Identifiable {
    var description = ""
    let id: UUID
    var isComplete = false
}

// MARK: - State
//

struct AppState: Equatable {
    var tasks: [Task]
}

// MARK: - Action
//

enum AppAction {
    case taskCheckboxTapped(index: Int)
    case taskTextFieldChanged(index: Int, text: String)
}

// MARK: - Environment
// holds the dependencies

struct AppEnvironment {

}

// MARK: - Reducer
// glues state, action and environment into a cohesive package
// responsible for the business logic that runs the app

let appReducer = Reducer<AppState, AppAction, AppEnvironment>
{ state, action, environment in
    switch action {
    case .taskCheckboxTapped(let index):
        state.tasks[index].isComplete.toggle()
    case .taskTextFieldChanged(let index, let text):
        state.tasks[index].description = text
    }
    // return effect ( side effect ) or .none
    return .none
}
// print action & state modification
.debug()

struct ContentView: View {

    // MARK: - Store

    let store: Store<AppState, AppAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEach(Array(viewStore.tasks.enumerated()), id: \.element.id) { index, task in
                        HStack {
                            Button(action: { viewStore.send(.taskCheckboxTapped(index: index)) }) {
                                Image(systemName: task.isComplete ? "checkmark.square" : "square")
                            }
                            .buttonStyle(PlainButtonStyle())

                            TextField(
                                "Untitled todo",
                                text: viewStore.binding(
                                    get: { $0.tasks[index].description },
                                    send: { .taskTextFieldChanged(index: index, text: $0) }
                                )
                            )
                        }
                        .foregroundColor(task.isComplete ? .gray : .none)
                    }
                }
                .navigationTitle("Tasks")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
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
                environment: AppEnvironment()
            )
        )
    }
}
