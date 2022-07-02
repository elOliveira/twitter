//
//  LoginController.swift
//  twiter
//
//  Created by cit on 02/07/22.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(imageLiteralResourceName: "TwitterLogo")
        return iv
    }()
    
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
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
    }
}
