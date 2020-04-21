//
//  MainViewController.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import ReusableKit
import RxViewController
import Then

final class MainViewController: BaseViewController, View {
    typealias Reactor = MainViewReactor
    
    // MARK: Properties
    
    private struct Metric {
        static let writeButtonWidthHeight: CGFloat = 60.0
        static let writeButtonMarginLeft: CGFloat = -30.0
        static let writeButtonMarginRight: CGFloat = -30.0
        static let writeButtonMarginBottom: CGFloat = -20.0
        static let writeButtonRadius: CGFloat = 30.0
        static let adViewHeight: CGFloat = 60.0
        static let adViewRadius: CGFloat = 20.0
        
        static let emptyImageWidthHeight: CGFloat = 128.0
        static let emptyMessageTop: CGFloat = 20.0
        static let emptyMessageSize: CGFloat = 14.0
        
        static let tableViewCellHeight: CGFloat = 55.0
    }
    
    private struct Localized {
        static let edit = NSLocalizedString("edit_title", comment: "편집")
        static let setting = NSLocalizedString("setting_title", comment: "설정")
        static let title = NSLocalizedString("app_title", comment: "복붙키보드")
        static let emptyMessage = NSLocalizedString("message_list_empty", comment: "등록된 내용이 없습니다")
    }
    
    private struct Reusable {
        static let mainCell = ReusableCell<MainTableViewCell>()
    }
    
    // MARK: Initializing
    
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.background
        $0.rowHeight = Metric.tableViewCellHeight
        $0.tableHeaderView = UIView(frame: .zero)
        $0.tableFooterView = UIView(frame: .zero)
        
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        $0.register(Reusable.mainCell)
        $0.separatorStyle = .singleLine
        $0.separatorInset.left = 0
    }
    
    private let writeButton = UIButton().then {
        $0.backgroundColor = .red
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Metric.writeButtonRadius
        $0.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
    }
    
    private let emptyView = UIView().then {
        $0.backgroundColor = Color.background
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
    
    
    private let leftBarButtonItem = UIBarButtonItem(title: Localized.edit, style: .plain, target: nil, action: nil)
    private let rightBarButtonItem = UIBarButtonItem(title: Localized.setting, style: .plain, target: nil, action: nil)
    private var dataSource: RxTableViewSectionedReloadDataSource<MainSection>?
    
    convenience override init() {
        let reactor = MainViewReactor()
        self.init(reactor: reactor)
    }
    
    init(reactor: MainViewReactor) {
        defer { self.reactor = reactor }
        super.init()
        self.dataSource = self.dataSourceFactory()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.debug("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.debug("viewWillAppear")
    }
    
    override func addViews() {
        super.addViews()
        self.setupView()
    }
    
    private func setupView() {
        
        
        self.view.backgroundColor = Color.background
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.emptyView.addSubview(emptyImageView)
        self.emptyView.addSubview(emptyMessageLabel)
        
        
        self.view.addSubview(tableView)
        self.view.addSubview(emptyView)
        self.view.addSubview(writeButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        writeButton.snp.makeConstraints { make in
            make.right.equalTo(Metric.writeButtonMarginRight)
            make.width.height.equalTo(Metric.writeButtonWidthHeight)
            make.bottom.equalTo(self.tableView.snp.bottom).offset(Metric.writeButtonMarginBottom)
        }
        
        emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        emptyMessageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(emptyImageView.snp.bottom).offset(Metric.emptyMessageTop)
            make.centerX.equalToSuperview()
            
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: MainViewReactor) {
        // Action
        rx.viewDidLoad
            .map { Localized.title }
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.loadWords }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        leftBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reactor?.action.onNext(.editing)
            })
            .disposed(by: self.disposeBag)
        
        rightBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let reactor = SettingViewReactor()
                let settingViewController = SettingViewController(reactor: reactor)
                self.navigationController?.pushViewController(settingViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let reactor = WriteViewReactor(mode: .write,
                                               text: nil)
                let writeViewController = WriteViewController(reactor: reactor)

                let navigationController = UINavigationController(rootViewController: writeViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
            })
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: self.dataSource!))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { !($0.sections.first?.items.isEmpty ?? false) }
            .bind(to: leftBarButtonItem.rx.isEnabled)
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
        
        reactor.state.map { $0.isEditing }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEditing in
                guard let self = self else { return }
                logger.debug(isEditing)
                self.tableView.setEditing(isEditing, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.reactor?.action.onNext(.deleteWord(indexPath))
                logger.debug("item deleted - \(indexPath)")
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemMoved
            .subscribe(onNext: { [weak self] moveItem in
                guard let self = self else { return }
                self.reactor?.action.onNext(.moveWord(sourceIndex: moveItem.sourceIndex.row,
                                                      destinationIndex: moveItem.destinationIndex.row))
                logger.debug("item moved - \(moveItem)")
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected(dataSource: self.dataSource!)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case let .listItem(cellReactor):
                    let message = cellReactor.currentState.list.message
                    let reactor = WriteViewReactor(mode: .edit,
                                                   text: message)
                    let writeViewController = WriteViewController(reactor: reactor)

                    let navigationController = UINavigationController(rootViewController: writeViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: DataSrouceFactory - configuration
    
    private func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<MainSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .listItem(let cellReactor):
                let cell = tableView.dequeue(Reusable.mainCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        }, canEditRowAtIndexPath: { _, _ in
            return true
        },
        canMoveRowAtIndexPath: { _, _ in
            return true
        })
    }
    
}
