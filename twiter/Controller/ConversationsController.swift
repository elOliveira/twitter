//
//  ConversationsController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit

class ConversationsController: UITabBarController {
    
    // MARK: - Propertyes
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    func configureUi() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }

    // MARK: - Helpers
}
