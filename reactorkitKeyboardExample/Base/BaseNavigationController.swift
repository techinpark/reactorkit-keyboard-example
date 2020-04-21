//
//  BaseNavigationController.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // MARK: - Properties
    
    // MARK: - Initialize
    
    // MARK: Rx
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.title
        ]
    }
    
    deinit {
        logger.verbose("DEINIT: \(self.className)")
    }
    
    // MARK: - Layout Constraints
    
    // MARK: - Configure
}
