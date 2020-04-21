//
//  WriteViewReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift


final class WriteViewReactor: Reactor {
    
    enum ContentMode {
        case write
        case edit
    }
    
    enum Action {
        case initializeData
        case getPasteboard
        case getIndex
        case edit(String)
        case save(String)
    }
    
    enum Mutation {
        case getIndex
        case setText(String)
        case edit(String)
        case save(String)
    }
    
    struct State {
        var text: String?
        var isUpdated: Bool = false
        var mode: ContentMode
        var currentIndex: Int?
    }
    
    let initialState: State
    let utility = Utility()
    
    // MARK: Initializing
    
    init(mode: ContentMode, text: String?) {
        initialState = State(text: text, mode: mode)
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initializeData:
            switch currentState.mode {
            case .edit:
                return .just(Mutation.getIndex)
            case .write:
                return .empty()
            default:
                return .empty()
            }
        case .getIndex:
            return .just(Mutation.getIndex)
        case .getPasteboard:
            let text = getPasteboard()
            return .just(.setText(text))
        case let .edit(text):
            return .just(.edit(text))
        case let .save(text):
            return .just(.save(text))
            
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .getIndex:
            if let text = state.text {
                let index = utility.getIndex(text: text)
                state.currentIndex = index
            }
            return state
            
        case let .setText(string):
            state.text = string
            return state
            
        case let .edit(text):
            if let index = state.currentIndex {
                let isEdited = utility.updateWord(index: index, text: text)
                state.isUpdated = isEdited
                return state
            }
            
        case let .save(text):
            let isSaved = utility.saveWord(text: text)
            state.isUpdated = isSaved
            return state
        }
        
        return state
    }
    
    func getPasteboard() -> String {
        guard let copyText = UIPasteboard.general.string else { return "" }
        if copyText.isEmpty == false {
            logger.verbose("[+] detected something in clipboard")
            return copyText
        }
        
        return ""
    }
}
