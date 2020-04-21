//
//  BaseInputViewController.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit
import RxSwift

class BaseInputViewController: UIInputViewController {

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addViews()
        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("updateViewConstraints")
    }

    func addViews() {
        print("addViews")
    }

}
