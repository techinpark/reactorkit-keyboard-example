//
//  SettingSectionFooterViewReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//


import ReactorKit
import RxCocoa
import RxSwift

class SettingSectionFooterViewReactor: Reactor {

    typealias Action = NoAction

    struct State {
        var type: SettingFooterType
    }

    let initialState: State

    init(type: SettingFooterType) {
        initialState = State(type: type)
    }
}
