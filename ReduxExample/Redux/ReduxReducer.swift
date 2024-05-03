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
    associatedtype State: ReduxState
    associatedtype Actions
    
    /// 뷰의 현재 상태
    var state: State { get set }
    /// 뷰의 `ReduxAction` 을 감지하기 위한 Observable
    var actionSubject: PublishSubject<Actions> { get }
    /// State 가 변경되었을 경우 제일 먼저 작동하는 Observable
    var _actionCommit: BehaviorRelay<State> { get }
    
    /// `actionSubject` 에 의한 State 변경 로직을 담은 함수
    func reduce(_ action: Actions) -> ReducerAction<Self>
    
    var disposeBag: DisposeBag { get set }
}

extension ReduxReducer {
    var actionCommit: Observable<Self.State> {
        _actionCommit.observeOn(MainScheduler.instance)
    }
}

extension ReduxView {
    func start() {
        reducer.actionSubject
            .subscribe(onNext: { action in
                switch reducer.reduce(action) {
                case .none:
                    reducer._actionCommit.accept(reducer.state)
                case .async(let handler):
                    Task { await handler(reducer.state) }
                case .send(let action):
                    reducer.actionSubject.onNext(action)
                }
            })
            .disposed(by: reducer.disposeBag)
    }
}
