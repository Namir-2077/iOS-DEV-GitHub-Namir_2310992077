//
//  IndigoViewController.swift
//  Tab Bar
//
//  Created by student on 21/07/25.
//

import UIKit

class IndigoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.badgeValue = "4"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarItem.badgeValue = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarItem.badgeValue = "3"
    }

}
