//
//  MainReducer.swift
//  ReduxExample
//
//  Created by 백상휘 on 4/26/24.
//

import Foundation
import RxSwift
import RxRelay

final class MainReducer: ReduxReducer {
    typealias State = MainReducerState
    
    enum StepperButton {
        case minus, plus
    }
    enum ModelEditEvent {
        case add(String), removeAt(Int), removeAll
    }
    
    enum Actions {
        case stepperChanged(StepperButton)
        case alertCall
        case randomTable
        case modelEdit(ModelEditEvent)
    }
    
    let actionSubject = PublishSubject<Actions>()
    let _actionCommit = BehaviorRelay<MainReducerState>(value: .init())
    
    var state = MainReducerState()
    var disposeBag: DisposeBag = .init()
    
    private var models = [
        "The sun is shining brightly in the sky."
        , "I love reading books on my favorite topic, history."
        , "The cat purrs contentedly on my lap."
        , "It's time to go to bed, don't you think?"
        , "She has a beautiful smile that lights up the room."
        , "My favorite food is pizza with extra cheese."
        , "The city is very busy during rush hour."
        , "I'm looking forward to my summer vacation."
        , "The new employee is really nice and easy to talk to."
        , "The park is a lovely place to take a walk on a sunny day."
    ]
    
    func reduce(_ action: Actions) -> ReducerAction<MainReducer> {
        switch action {
        case .stepperChanged(let button):
            state.stepperValue += (button == .plus) ? 1 : -1
            return .none
        case .alertCall:
            return .none
        case .randomTable:
            return .async { [weak actionSubject] state in
                actionSubject?.onNext(.modelEdit(.removeAll))
                
                let tempModels = self.models
                    .compactMap { str -> String? in
                        [0,1].randomElement() == 1 ? str : nil
                    }
                    .shuffled()
                
                for tempModel in tempModels {
                    actionSubject?.onNext(
                        .modelEdit(.add(tempModel))
                    )
                    usleep(500000)
                }
            }
        case .modelEdit(let event):
            switch event {
            case .add(let model):
                state.models.append(model)
            case .removeAt(let index):
                state.models.remove(at: index)
            case .removeAll:
                state.models.removeAll()
            }
            
            return .none
        }
    }
}

struct MainReducerState: ReduxState {
    var stepperValue: Int = 0
    var alertMessage: String = ""
    var models: [String] = []
}
