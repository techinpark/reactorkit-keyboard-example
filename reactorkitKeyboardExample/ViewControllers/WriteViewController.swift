//
//  WriteViewController.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class WriteViewController: BaseViewController, View {

    // MARK: Properties

    private struct Metric {
        static let textViewTop: CGFloat = 15.0
        static let textSize: CGFloat = 15.0
    }

    private struct Font {
        static let textViewStyle = UIFont.systemFont(ofSize: Metric.textSize,
                                                     weight: .regular)
    }

    private struct Localized {
        static let writeTitle = NSLocalizedString("write_title", comment: "추가하기")
        static let editTitle = NSLocalizedString("edit_title", comment: "편집하기")
        static let close = NSLocalizedString("common_close", comment: "닫기")
        static let save = NSLocalizedString("common_save", comment: "저장")
    }

    // MARK: Initializing

    private let leftBarButtonItem = UIBarButtonItem(title: Localized.close,
                                                    style: .plain,
                                                    target: nil,
                                                    action: nil)

    private let rightBarButtonItem = UIBarButtonItem(title: Localized.save,
                                                     style: .plain,
                                                     target: nil,
                                                     action: nil)

    private let textView = UITextView().then {
        $0.backgroundColor = Color.background
        $0.textColor = Color.title
        $0.font = Font.textViewStyle
    }

    init(reactor: WriteViewReactor) {
        super.init()
        self.reactor = reactor
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

        self.view.backgroundColor = Color.background
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        view.addSubview(textView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        textView.snp.makeConstraints { make in
            make.top.equalTo(Metric.textViewTop)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    // MARK: Binding

    func bind(reactor: WriteViewReactor) {
        // State

        self.rx.viewDidLoad
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.textView.becomeFirstResponder()
            })
            .disposed(by: self.disposeBag)

        rx.viewWillAppear
            .map { _ in Reactor.Action.initializeData }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        leftBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        rightBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let mode = self.reactor?.currentState.mode
                switch mode {
                case .edit:
                    logger.verbose("edit")
                    let text = self.textView.text ?? ""
                    self.reactor?.action.onNext(.edit(text))
                case .write:
                    logger.verbose("save")
                    let text = self.textView.text ?? ""
                    self.reactor?.action.onNext(.save(text))
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        self.textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] string in
                guard let self = self else { return }

                if string.isEmpty {
                    self.rightBarButtonItem.isEnabled = false
                } else {
                    self.rightBarButtonItem.isEnabled = true
                }

                logger.debug(string)
            }).disposed(by: self.disposeBag)

        reactor.state.map { $0.text }
            .distinctUntilChanged()
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isUpdated }
            .filter{ $0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isUpdated in
                guard let self = self else { return }
                let mode = self.reactor?.currentState.mode
                switch mode {
                case .edit:
                    logger.verbose("편집 완료")
                    self.dismiss(animated: true, completion: nil)
                case .write:
                    logger.verbose("새로 추가 완료")
                    self.dismiss(animated: true, completion: nil)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.mode }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] mode in
                guard let self = self else { return }
                switch mode {
                case .edit:
                    self.title = Localized.editTitle
                case .write:
                    self.title = Localized.writeTitle
                }
            }).disposed(by: self.disposeBag)
    }

}
