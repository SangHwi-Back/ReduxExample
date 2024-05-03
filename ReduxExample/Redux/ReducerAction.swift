//
//  ReducerAction.swift
//  ReduxExample
//
//  Created by 백상휘 on 4/26/24.
//

import Foundation

indirect enum ReducerAction<R: ReduxReducer> {
    /// 동기 작업을 수행함. 뷰 업데이트를 하였을 경우 아래 action 을 반환
    case none
    /// 비동기 작업을 수행함. 이 자체로는 뷰 업데이트가 되지 않음.
    case async((R.State) async -> Void)
    /// 다른 Action 을 실행함.
    case send(R.Actions)
}
