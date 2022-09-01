//
//  UploadTweetViewModel.swift
//  twiter
//
//  Created by cit on 01/09/22.
//

import Foundation

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config:UploadTweetConfiguration){
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "Whats's happening"
            shouldShowReplyLabel = false
            
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.userName)"
        }
    }
}
