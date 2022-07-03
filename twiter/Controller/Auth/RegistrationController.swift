//
//  RegistrationController.swift
//  twiter
//
//  Created by cit on 02/07/22.
//

import UIKit
import Firebase

class RegistrationController: UIViewController{
    //MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "plus_photo")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.addTarget(nil, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
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

    private lazy var fullNameContainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
        return view
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:20)
        button.addTarget(nil, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let hasHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an acount?"," Login In")
        button.addTarget(nil, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
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
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "User Name")
        return tf
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        configureUi()
    }
    //MARK: - Selectors
    
    @objc func handleAddProfilePhoto(){
        present(imagePicker,animated: true, completion: nil)
    }
    
    @objc func handleRegister(){
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image...")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        print("OK 1")
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        print("OK 2")

        let filename = NSUUID().uuidString
        print("OK 3")

        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        print("OK 4")

        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            print("OK 5")

            storageRef.downloadURL{ (url, error) in
                print("OK 6")

//                guard let profileImageUrl = url?.absoluteString else { return } nao ta entrando
                print("OK 7")

                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    print("OK 8")

                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    print("OK 9")

                    guard let uid = result?.user.uid else { return }
                    print("OK 10")

                    let values = ["email":email,"password":password,"fullName":fullName,"userName":userName]
                    print("OK 11")


                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        print("DEBUG: Successfully updated user information...")
                    }
                    print("OK 12")

                }
            }
        }
    }

    @objc func handleShowLogin(){
        dismiss(animated: true)
    }
    //MARK: - Helpers
    
    func configureUi() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            passwordContainerView,
            fullNameContainerView,
            userNameContainerView,
            registerButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(
            top:plusPhotoButton.bottomAnchor,
            left:view.leftAnchor,
            right:view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )
        
        view.addSubview(hasHaveAccountButton)
        hasHaveAccountButton.anchor(
            left:   view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right:  view.rightAnchor,
            paddingLeft:    30,
            paddingRight:   30
        )
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return  }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true

        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true,completion: nil)
    }
}
