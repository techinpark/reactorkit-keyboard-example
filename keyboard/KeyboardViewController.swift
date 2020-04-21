//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReusableKit
import ReactorKit
import RxDataSources
import RxViewController

class KeyboardViewController: BaseInputViewController, ReactorKit.View {
    
    typealias Reactor = KeyboardViewReactor
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    private struct Metric {
        static let bottomButtonWidth: CGFloat = 80.0
        static let globalButtonWidth: CGFloat = 60.0
        static let deleteButtonWidth: CGFloat = 60.0
        static let enterButtonWidth: CGFloat = 80.0
        static let bottomButtonHeight: CGFloat = 45.0
        static let spaceButtonWidth: CGFloat = 100.0
        static let marginButtonLeftRight: CGFloat = 4.0
        static let buttonCornerRadius: CGFloat = 8.0
        
        static let tableViewCellHeight: CGFloat = 40.0
        static let tableViewHeight: CGFloat = 200.0
        static let textSize: CGFloat = 15.0
        
        static let emptyImageWidthHeight: CGFloat = 128.0
        static let emptyMessageTop: CGFloat = 20.0
        static let emptyMessageSize: CGFloat = 14.0
    }
    
    private struct Localized {
        static let space = NSLocalizedString("space", comment: "스페이스바")
        static let emptyMessage = NSLocalizedString("message_list_empty", comment: "등록된 내용이 없습니다")
    }
    
    private struct Reusable {
        static let listCell = ReusableCell<ListCell>()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        defer { self.reactor = KeyboardViewReactor() }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.dataSource = self.dataSourceFactory()
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ListSection>?
    
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.keyboardBackground
        $0.rowHeight = Metric.tableViewCellHeight
        $0.tableHeaderView = UIView(frame: .zero)
        $0.tableFooterView = UIView(frame: .zero)
        $0.bounces = false
        
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        $0.register(Reusable.listCell)
        $0.separatorStyle = .singleLine
        $0.separatorInset.left = 0
    }
    
    private let bottomWrapView = UIView().then {
        $0.backgroundColor = Color.keyboardBackground
    }
    
    private let emptyView = UIView().then {
        $0.backgroundColor = Color.keyboardBackground
        $0.isHidden = true
    }
    
    private let emptyImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "clipboard")
    }
    
    private let emptyMessageLabel = UILabel().then {
        $0.text = Localized.emptyMessage
        $0.font = UIFont.systemFont(ofSize: Metric.emptyMessageSize)
        $0.textColor = Color.description
        $0.sizeToFit()
    }
    
    private let globalButton = UIButton().then {
        $0.layer.borderWidth = 0.3
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Metric.buttonCornerRadius
        $0.setImage(#imageLiteral(resourceName: "global"), for: .normal)
        $0.setBackgroundColor(Color.keyBackground, for: .normal)
    }
    
    private let spaceButton = UIButton().then {
        $0.layer.borderWidth = 0.3
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Metric.buttonCornerRadius
        $0.setTitle(Localized.space, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: Metric.textSize)
        $0.setTitleColor(Color.title, for:.normal)
        $0.setBackgroundColor(Color.keySpaceBackground, for: .normal)
    }
    
    private let deleteButton = UIButton().then {
        $0.layer.borderWidth = 0.3
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Metric.buttonCornerRadius
        $0.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        $0.setBackgroundColor(Color.keyBackground, for: .normal)
    }
    
    private let enterButton = UIButton().then {
        $0.layer.borderWidth = 0.3
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Metric.buttonCornerRadius
        $0.setImage(#imageLiteral(resourceName: "return"), for: .normal)
        $0.setBackgroundColor(Color.keyBackground, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addViews() {
        super.addViews()
        
        if needsInputModeSwitchKey {
            self.bottomWrapView.addSubview(globalButton)
        }
        
        self.bottomWrapView.addSubview(spaceButton)
        self.bottomWrapView.addSubview(deleteButton)
        self.bottomWrapView.addSubview(enterButton)
        
        self.emptyView.addSubview(emptyImageView)
        self.emptyView.addSubview(emptyMessageLabel)
        
        self.view.addSubview(bottomWrapView)
        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.view.snp.makeConstraints { make in
            make.height.equalTo(Metric.bottomButtonHeight + Metric.tableViewHeight)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        bottomWrapView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Metric.bottomButtonHeight)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomWrapView.snp.top)
        }
        
        emptyView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomWrapView.snp.top)
        }
        
        emptyImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        emptyMessageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emptyImageView.snp.bottom).offset(Metric.emptyMessageTop)
            make.centerX.equalToSuperview()
        }
        
        if needsInputModeSwitchKey {
            globalButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-Metric.marginButtonLeftRight)
                make.top.equalToSuperview().offset(Metric.marginButtonLeftRight)
                make.left.equalToSuperview().offset(Metric.marginButtonLeftRight)
                make.width.equalTo(Metric.globalButtonWidth)
            }
            
            spaceButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-Metric.marginButtonLeftRight)
                make.top.equalToSuperview().offset(Metric.marginButtonLeftRight)
                make.left.equalTo(globalButton.snp.right).offset(Metric.marginButtonLeftRight)
            }
        } else {
            spaceButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-Metric.marginButtonLeftRight)
                make.top.equalToSuperview().offset(Metric.marginButtonLeftRight)
                make.left.equalToSuperview().offset(Metric.marginButtonLeftRight)
            }
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Metric.marginButtonLeftRight)
            make.top.equalToSuperview().offset(Metric.marginButtonLeftRight)
            make.left.equalTo(spaceButton.snp.right).offset(Metric.marginButtonLeftRight)
            make.width.equalTo(Metric.deleteButtonWidth)
        }
        
        enterButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Metric.marginButtonLeftRight)
            make.top.equalToSuperview().offset(Metric.marginButtonLeftRight)
            make.left.equalTo(deleteButton.snp.right).offset(Metric.marginButtonLeftRight)
            make.right.equalToSuperview().offset(-Metric.marginButtonLeftRight)
            make.width.equalTo(Metric.enterButtonWidth)
        }
    }
    
    func bind(reactor: KeyboardViewReactor) {
        
        // Action
        rx.viewDidLoad
            .map { _ in Reactor.Action.loadWords }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.spaceButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tapSpaceBar()
            }).disposed(by: self.disposeBag)
        
        self.globalButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tapGlobal()
            }).disposed(by: self.disposeBag)
        
        self.deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tapDelete()
            }).disposed(by: self.disposeBag)
        
        self.enterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tapEnter()
            }).disposed(by: self.disposeBag)
        
        // State
        
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: self.dataSource!))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections.first?.items }
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                if let items = items {
                    if items.isEmpty {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                logger.verbose("click")
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected(dataSource: self.dataSource!)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case let .listItem(cellReactor):
                    let message = cellReactor.currentState.list.message
                    self.textDocumentProxy.insertText(message)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: DataSrouceFactory - configuration
    
    private func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<ListSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .listItem(let cellReactor):
                let cell = tableView.dequeue(Reusable.listCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    override func viewWillLayoutSubviews() {}
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    // MARK: private function
    
    func tapGlobal() {
        logger.verbose("tapGlobal")
        self.advanceToNextInputMode()
    }
    
    func tapSpaceBar() {
        logger.verbose("tapSpaceBar")
        self.textDocumentProxy.insertText(" ")
    }
    
    func tapEnter() {
        self.textDocumentProxy.insertText("\n")
    }
    
    func tapDelete() {
        self.textDocumentProxy.deleteBackward()
    }
}
