//
//  MainTableViewCellReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MainTableViewCellReactor: Reactor {
    typealias Action = NoAction
    typealias Mutaiton = NoMutation

    struct State {
        var list: MainViewReactor.Item
    }

    let initialState: State

    init(list: MainViewReactor.Item) {
        initialState = State(list: list)
    }
}
