//
//  TaskView.swift
//  TCA-ToDoList
//
//  Created by Merouane Bellaha on 29/09/2020.
//

import SwiftUI
import ComposableArchitecture


// MARK: - State

struct Task: Equatable, Identifiable {
    var description = ""
    let id: UUID
    var isComplete = false
}

// MARK: - Action

enum TaskAction {
    case checkboxTapped
    case textFieldChanged(String)
}

// MARK: - Environment

struct TaskEnvironment {

}

// MARK: - Reducer

let taskReducer = Reducer<Task, TaskAction, TaskEnvironment>
{ state, action, environment in
    switch action {
    case .checkboxTapped:
        state.isComplete.toggle()
    case .textFieldChanged(let text):
        state.description = text
    }
    // return effect ( side effect ) or .none
    return .none
}

struct TaskView: View {

    // MARK: - Store
    
    var store: Store<Task, TaskAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button(action: { viewStore.send(.checkboxTapped) }) {
                    Image(systemName: viewStore.isComplete ?
                            "checkmark.square" :
                            "square")
                }
                .buttonStyle(PlainButtonStyle())

                TextField(
                    "Untitled todo",
                    text: viewStore.binding(
                        get: \.description,
                        send: TaskAction.textFieldChanged
                    )
                )
            }
            .foregroundColor(viewStore.isComplete ? .gray : .none)
        }
    }
}

//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView()
//    }
//}
