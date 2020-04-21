//
//  MainViewReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//


import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class MainViewReactor: Reactor {
    
    typealias SectionItem = MainSectionItem
    
    enum Item {
        case word(String)
        
        var message: String {
            switch self {
            case let .word(message):
                return message
            }
        }
    }
    
    enum Action {
        case loadWords
        case copyWord(String)
        case setToastMessage(String)
        case editing
        case moveWord(sourceIndex: Int, destinationIndex: Int)
        case deleteWord(IndexPath)
    }
    
    enum Mutation {
        case loadWords
        case moveWord(sourceIndex: Int, destinationIndex: Int)
        case deleteWord(Int)
        case setClipboard(String)
        case setToastMessage(String)
        case editing(Bool)
    }
    
    struct State {
        
        var words: [String] = []
        var toastMessage: String?
        var isEditing: Bool = false
        var isUpdated: Bool = false
        var isMoved: Bool = false
        
        var sections: [MainSection] {
            let sectionItems = words.map { word -> MainTableViewCellReactor in
                return MainTableViewCellReactor(list: Item.word(word))
            }.map(MainSectionItem.listItem)
            return [.list(sectionItems)]
        }
    }
    
    let initialState: State
    let utility = Utility()
    // MARK: Initializing
    
    init() {
        initialState = State()
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadWords:
            return .just(Mutation.loadWords)
        case let .copyWord(word):
            return .just(Mutation.setClipboard(word))
        case let .setToastMessage(message):
            return .just(Mutation.setToastMessage(message))
        case .editing:
            if false == self.currentState.isEditing {
                return .just(Mutation.editing(true))
            } else {
                return .just(Mutation.editing(false))
            }
        case let .moveWord(moveEvent):
            
            let moveWordMutation = Mutation.moveWord(sourceIndex: moveEvent.sourceIndex,
                                                     destinationIndex: moveEvent.destinationIndex)
            
            return .concat([.just(moveWordMutation),
                            .just(Mutation.loadWords)])
            
        case let .deleteWord(indexPath):
            return .just(.deleteWord(indexPath.row))
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadWords:
            var originWords = state.words
            originWords.removeAll()
            originWords = utility.getWords()
            
            state.words = originWords
            return state
        case let .moveWord(sourceIndex, destinationIndex):
            let isMoved = utility.moveWords(source: sourceIndex,
                                            destination: destinationIndex)
            state.isMoved = isMoved
            return state
        case let .deleteWord(index):
            let isUpdated = utility.deleteWord(index: index)
            state.isUpdated = isUpdated
            state.words = utility.getWords()
            return state
        case let .setClipboard(word):
            self.setPasteboard(string: word)
            return state
        case let .setToastMessage(message):
            state.toastMessage = message
            return state
        case let .editing(isEditing):
            state.isEditing = isEditing
            return state
            
        }
    }
    
    private func setPasteboard(string: String) {
        UIPasteboard.general.string = string
    }
}
