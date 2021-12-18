//
//  UIViewController+.swift
//  LoginScreen
//
//  Created by  Paul on 17.12.2021.
//

import UIKit

extension UIViewController
{
    /// This is a function to get all **content** (NOT child) controllers of a particular type from controller recursively. It would look recursively inside UINavigationControllers and UITabBarControllers
    func allContentControllersOf<T : UIViewController>(type : T.Type) -> [T] {
        var all = [T]()
        func getContentControllers(for controller: UIViewController) {
            if let controller = controller as? T {
                all.append(controller)
            }
            if let navCon = controller as? UINavigationController {
                navCon.viewControllers.forEach{ getContentControllers(for: $0) }
            } else if let tabCon = controller as? UITabBarController,
                      let controllers = tabCon.viewControllers  {
                controllers.forEach{ getContentControllers(for: $0) }
            } else if let splitCon = controller as? UISplitViewController {
                splitCon.viewControllers.forEach{ getContentControllers(for: $0) }
           }
        }
        getContentControllers(for: self)
        return all
    }
}
