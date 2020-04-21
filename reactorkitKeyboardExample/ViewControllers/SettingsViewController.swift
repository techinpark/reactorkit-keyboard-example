//
//  SettingsViewController.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import SafariServices
import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxSwift
import AcknowList

final class SettingViewController: BaseViewController, View {
    // MARK: Properties
    
    private struct Metric {
        static let tableViewCellHeight: CGFloat = 44.0
        static let sectionFooterHeight: CGFloat = 30.0
        static let sectionThanksFooterHeight: CGFloat = 60.0
    }
    
    private struct Font {}
    
    private struct Reusable {
        static let settingCell = ReusableCell<SettingCell>()
    }
    
    private struct Localized {
        static let setting = NSLocalizedString("setting_title", comment: "Settings")
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SettingSection>!
    
    // MARK: UI Views
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.rowHeight = Metric.tableViewCellHeight
        $0.register(Reusable.settingCell)
        $0.separatorStyle = .singleLine
    }
    
    // MARK: Initializing
    
    init(reactor: SettingViewReactor) {
        defer { self.reactor = reactor }
        super.init()
        dataSource = dataSourceFactory()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addViews() {
        super.addViews()
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: SettingViewReactor) {
        // Action
        rx.viewDidLoad
            .map { Localized.setting }
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected(dataSource: dataSource!)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .openSource:
                    let viewController = AcknowListViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                
                case .githubRepo:
                    self.pushToWebVC(urlString: Constants.ETC.repoURL)
                }
            }).disposed(by: disposeBag)
    }
    
    private func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<SettingSection> {
        return .init(configureCell: { (_, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case let .openSource(cellReactor):
                let cell = tableView.dequeue(Reusable.settingCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            case let .githubRepo(cellReactor):
                let cell = tableView.dequeue(Reusable.settingCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    private func donate() {
        guard let firstLanguage = Locale.preferredLanguages.first else { return }
        
        
        let urlString = firstLanguage.hasPrefix("ko") ? WebLinks.kakaoChat : WebLinks.SurveyFormGoogle
        pushToWebVC(urlString: urlString)
    }
    
    // MARK: Route
    
    private func pushToWebVC(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    private func openURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let type = SettingFooterType(rawValue: section) else { return nil }
        let footerReactor = SettingSectionFooterViewReactor(type: type)
        return SettingSectionFooterView(reactor: footerReactor)
    }
    
    func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let type = SettingFooterType(rawValue: section) else { return 0.0 }
        switch type {
        case .dataComment:
            return Metric.sectionFooterHeight
        }
    }
}
