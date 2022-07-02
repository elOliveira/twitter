//
//  FeedController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit

class FeedController: UITabBarController {

    // MARK: - Propertyes

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    func configureUi() {
        view.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    // MARK: - Helpers

    
}
