//
//  Tweet.swift
//  twiter
//
//  Created by cit on 16/08/22.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    let uidUserCreatedTweet: String
    let likes: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    
    init(user:User, tweetID:String, dictionary:[String: Any]){
        self.tweetId = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uidUserCreatedTweet = dictionary["uidUserCreatedTweet"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweetCount"] as? Int ?? 0

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }

    }
}
