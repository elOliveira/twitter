//
//  TwitterVIewModel.swift
//  twiter
//
//  Created by cit on 19/08/22.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user : User
    var profileImageUrl: URL? { return user.profileImageUrl  }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute , .hour , .day , .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var userNameText: String {
        return "@\(user.userName)"
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue:tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue:tweet.likes, text: "Likes")
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]))
        
        title.append(NSAttributedString(string: " • \(timestamp)", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]))
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    init(tweet:Tweet){
        self.tweet = tweet
        self.user = tweet.user
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
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
