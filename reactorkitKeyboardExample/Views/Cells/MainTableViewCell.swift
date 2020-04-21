//
//  MainTableViewCell.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MainTableViewCell: BaseTableViewCell, View {
    
    typealias Reactor = MainTableViewCellReactor
    
    private struct Metric {
        static let titleLeft: CGFloat = 10.0
    }
    
    // MARK: Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Initializing
    override func addViews() {
        super.addViews()
        self.contentView.backgroundColor = Color.background
        self.selectionStyle = .none
    }
    
    override func setupConstraints() {
        super.setupConstraints()
    }
    
    // MARK: Binding
    func bind(reactor: MainTableViewCellReactor) {
        
        reactor.state.map { $0.list.message }
            .distinctUntilChanged()
            .bind(to: self.textLabel!.rx.text)
            .disposed(by: self.disposeBag)
    }
}

