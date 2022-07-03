//
//  MainTabController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Propeties
    
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
        configureUi()
        configureViewControllers()
        
    }
    // MARK: - Selectors

    @objc func actionButtonTapped(){
        print("APERTOU")
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
        
        let feed = FeedController()
        let navFeed =  templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        //
        let explore = ExploreController()
        let navExplore =  templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        let notifications = NotificationsController()
        let navNotifications =  templateNavigationController(image: UIImage(named: "ic_menu_white_3x"), rootViewController: notifications)

        let conversations = ConversationsController()
        let navConversations =  templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)

        viewControllers = [navFeed,navExplore,navNotifications,navConversations]
    }
    
    func templateNavigationController(image: UIImage?,rootViewController: UIViewController)-> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
