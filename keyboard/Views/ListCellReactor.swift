//
//  ListCellReactor.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ListCellReactor: Reactor {
    typealias Action = NoAction
    typealias Mutaiton = NoMutation

    struct State {
        var list: KeyboardViewReactor.Item
    }

    let initialState: State

    init(list: KeyboardViewReactor.Item) {
        initialState = State(list: list)
    }
}
