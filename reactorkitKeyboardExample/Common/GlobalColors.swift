//
//  GlobalColors.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import UIKit

struct Color {
    static let title: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return .white
                } else {
                    // Return color for Light Mode
                    return .black
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return .black
        }
    }()
    
    static let description: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return .gray
                } else {
                    // Return color for Light Mode
                    return .gray
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return .gray
        }
    }()
    
    
    

    static let background: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return .black
                } else {
                    // Return color for Light Mode
                    return .white
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return .white
        }
    }()

    static let textColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return .white
                } else {
                    // Return color for Light Mode
                    return .black
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return .black
        }
    }()

    static let red: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return UIColor.init(red: 248, green: 44, blue: 84, alpha: 1.0)
                } else {
                    // Return color for Light Mode
                    return UIColor.init(red: 248, green: 7, blue: 63, alpha: 1.0)
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return UIColor.init(red: 248, green: 7, blue: 63, alpha: 1.0)
        }
    }()
    
    static let keySpaceBackground: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return UIColor(red: 106, green: 106, blue: 106)
                } else {
                    // Return color for Light Mode
                    return .white
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
             return .white
        }
    }()
    
    static let keyBackground: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return UIColor(red: 71, green: 71, blue: 71)
                } else {
                    // Return color for Light Mode
                    return UIColor(red: 180, green: 184, blue: 192)
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return UIColor(red: 180, green: 184, blue: 192)
        }
    }()
    
    static let keyboardBackground: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return UIColor(red: 43, green: 43, blue: 43)
                } else {
                    // Return color for Light Mode
                    return UIColor(red: 214, green: 216, blue: 221)
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return UIColor(red: 214, green: 216, blue: 221)
        }
    }()
    
    static let keyboardListBackground: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return color for Dark Mode
                    return UIColor(red: 43, green: 43, blue: 43)
                } else {
                    // Return color for Light Mode
                    return .white
                }
            }
        } else {
            // Return fallback color for iOS 12 and lower
            return .white
        }
    }()
}
