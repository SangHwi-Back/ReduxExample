//
//  ReduxReducer.swift
//  ReduxExample
//
//  Created by 백상휘 on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReduxReducer {
    associatedtype State: ReducerState
    associatedtype RA = ReducerAction<Self>
    associatedtype Actions
    
    var state: State { get set }
    var _state: BehaviorSubject<State> { get }
    func reduce(_ action: Actions) -> RA
    
    var disposeBag: DisposeBag { get set }
}

extension ReduxView {
    func start(
        _ handler: @escaping (Result<R.State, Error>) -> Void
    ) {
        reducer._state
            .distinctUntilChanged()
            .subscribe { newState in
                switch newState.event {
                case .next(let value):
                    handler(.success(value))
                case .error(let error):
                    handler(.failure(error))
                case .completed:
                    print("completed")
                }
            }
            .disposed(by: reducer.disposeBag)
    }
}

extension Reactive where Base: ReducerState {
    var reducedState: Observable<Base> {
        return Observable<Base>.create { observer in
            observer.onNext(base)
            return Disposables.create()
        }
    }
}
