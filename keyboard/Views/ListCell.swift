//
//  ListCell.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class ListCell: BaseTableViewCell, ReactorKit.View {
    
    // MARK: Properties
    typealias Reactor = ListCellReactor
    
    // MARK: Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.textLabel?.textColor = Color.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Initializing
    
    override func addViews() {
        super.addViews()
        self.contentView.backgroundColor = Color.keyboardListBackground
        self.selectionStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    // MARK: Binding
    
    func bind(reactor: ListCellReactor) {
        
        reactor.state.map { $0.list.message }
            .distinctUntilChanged()
            .bind(to: self.textLabel!.rx.text)
            .disposed(by: self.disposeBag)
    }
}
