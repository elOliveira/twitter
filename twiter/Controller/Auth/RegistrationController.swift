//
//  RegistrationController.swift
//  twiter
//
//  Created by cit on 02/07/22.
//

import Foundation
import UIKit

class RegistrationController: UIViewController {
    //MARK: - Properties

    //MARK: - Lifecycle
    override func viewDidLoad() {
        configureUi()
    }
    //MARK: - Selectors
    //MARK: - Helpers
    
    func configureUi() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
}
