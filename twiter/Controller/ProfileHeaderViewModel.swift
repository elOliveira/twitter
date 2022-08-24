//
//  ProfileHeaderViewModel.swift
//  twiter
//
//  Created by cit on 23/08/22.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 0, text: "following")
    }
    
    var actionButtonTitle: String {
        return user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    init(user: User){
        self.user = user
        self.usernameText = "@\(user.userName)"
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes:
                                                    [
                                                        .font: UIFont.boldSystemFont(ofSize: 14),
                                                        .foregroundColor: UIColor.lightGray
                                                    ]
                                                 ))
        return attributedTitle
    }
}
