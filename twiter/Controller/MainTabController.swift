//
//  MainTabController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    // MARK: - Propeties
    
    var user: User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for:.normal)
        button.addTarget(nil, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
        //        logUserOut()
    }
    // MARK: - API
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = UINavigationController(rootViewController: LoginController())
                loginController.modalPresentationStyle = .fullScreen
                self.present(loginController, animated: true)
            }
        } else {
            configureViewControllers()
            configureUi()
            fetchUser()
        }
    }
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser(){
        guard let uidCurrentUser = Auth.auth().currentUser?.uid else {return }
        UserService.shared.fetchUser(uid: uidCurrentUser) { user in
            self.user = user
        }
    }
    
    // MARK: - Selectors

    @objc func actionButtonTapped(){
        guard let user = user else { return }
        let uploadTweetController = UploadTweetController(user:user, config: .tweet)
        let nav = UINavigationController(rootViewController: uploadTweetController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUi(){
        view.addSubview(actionButton)
        actionButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right:  view.rightAnchor,
            paddingBottom: 64,
            paddingRight: 16,
            width: 56,
            height: 56
        )
        actionButton.layer.cornerRadius = 56/2
    }
    
    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navFeed =  templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let navExplore =  templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        let notifications = NotificationsController()
        let navNotifications =  templateNavigationController(image: UIImage(named: "ic_menu_white_3x"), rootViewController: notifications)

        let conversations = ConversationsController()
        let navConversations =  templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)

        viewControllers = [navFeed,navExplore,navNotifications,navConversations]
    }
    
    func templateNavigationController(image: UIImage?,rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
