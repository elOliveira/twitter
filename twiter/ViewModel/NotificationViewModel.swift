//
//  NotificationViewModel.swift
//  twiter
//
//  Created by cit on 05/09/22.
//

import Foundation
import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute , .hour , .day , .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }

    
    var notificationMessage : String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked your tweet"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeted your tweet"
        case .mention: return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil}
        let attributedText = NSMutableAttributedString(string: user.userName,
                                                       attributes: [.font: UIFont.boldSystemFont(ofSize: 12)]
        )
        
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
        attributedText.append(NSAttributedString(string: " \(timestamp)",
                                                  attributes:
                                                    [
                                                        .font: UIFont.boldSystemFont(ofSize: 12),
                                                        .foregroundColor: UIColor.lightGray
                                                    ]
                                                 ))
        
        return attributedText
        
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFolowed ? "Following" : "Follow"
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.user = notification.user
        self.type = notification.type
    }
    
}
