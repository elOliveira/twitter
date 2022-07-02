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
    //ic_mail_outline_white_2x-1
    //ic_lock_outline_white_2x
    private lazy var emailContainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
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
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top:logoImageView.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingLeft: 16, paddingRight: 16)
    }
}
