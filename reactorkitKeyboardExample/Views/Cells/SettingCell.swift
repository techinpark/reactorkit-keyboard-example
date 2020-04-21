//
//  SettingCell.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class SettingCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = SettingCellReactor
    
    // MARK: Properties
    
    // MARK: Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        super.addViews()
        // self.contentView.backgroundColor = .white
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    // MARK: Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.type.title }
            .bind(to: self.textLabel!.rx.text)
            .disposed(by: self.disposeBag)
    }
}

