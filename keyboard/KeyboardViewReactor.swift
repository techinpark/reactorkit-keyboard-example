//
//  KeyboardViewReactor.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class KeyboardViewReactor: Reactor {
    
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
        case getClipboard
    }
    
    enum Mutation {
        case loadWords
        case getClipboard
    }
    
    struct State {
        
        var words: [String] = []
        var toastMessage: String?
        var clipboardString: String?
        
        var sections: [ListSection] {
            let sectionItems = words.map { word -> ListCellReactor in
                return ListCellReactor(list: Item.word(word))
            }.map(ListSectionItem.listItem)
            return [.list(sectionItems)]
        }
    }
    
    let initialState: State
    
    // MARK: Initializing
    
    init() {
        initialState = State()
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadWords:
            return .just(Mutation.loadWords)
        case .getClipboard:
            return .just(Mutation.getClipboard)
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadWords:
            let words = self.getWords()
            state.words = words
            return state
        case .getClipboard:
            let words = self.getPasteboard()
            state.clipboardString = words
            return state
        }
    }
    
    // MARK: Private
    private func getWords() -> [String] {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return [] }
        if let data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            logger.verbose(data)
            return data
        }
        
        return []
    }
    
    private func setPasteboard(string: String) {
        UIPasteboard.general.string = string
    }
    
    private func getPasteboard() -> String? {
        if let string = UIPasteboard.general.string {
            return string
        }
        
        return nil
    }
}
