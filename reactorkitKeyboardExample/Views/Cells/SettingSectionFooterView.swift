//
//  SettingSectionFooterView.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class SettingSectionFooterView: UIView, ReactorKit.View {
    
    typealias Reactor = SettingSectionFooterViewReactor
    
    // MARK: Properties
    private struct Metric {
        static let descriptionLeading: CGFloat = 10.0
        static let descriptionTrailing: CGFloat = -10.0
    }
    
    private struct Font {
        static let description = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Views
    private let descriptionLabel = UILabel().then {
        $0.font = Font.description
        $0.textColor = Color.description
        $0.text = ""
        $0.textAlignment = .left
    }
    
    // MARK: Initializing
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(Metric.descriptionLeading)
            make.trailing.equalTo(Metric.descriptionTrailing)
            make.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.type.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
