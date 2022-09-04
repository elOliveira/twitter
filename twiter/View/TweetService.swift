//
//  TweetService.swift
//  twiter
//
//  Created by cit on 16/08/22.
//

import Foundation
import Firebase

class TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String,type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let selfUid  = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uidUserCreatedTweet": selfUid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "likes":     0,
            "retweets":  0,
            "caption":   caption
        ] as [String : Any]

        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { (error, reference) in
                guard let tweetID = reference.key else { return }
                REF_USER_TWEETS.child(selfUid).updateChildValues([tweetID:1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEETS_REPLIES.child(tweet.tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
        
    }
    
    func fetchTweets(completion: @escaping([Tweet])-> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded){ snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uidUserCreatedTweet = dictionary["uidUserCreatedTweet"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uidUserCreatedTweet) { user in
                let tweet = Tweet(user: user, tweetID: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet])-> Void){
        var tweets = [Tweet]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded){ snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uidUserCreatedTweet"] as? String else { return }

                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: uid, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet])-> Void){
        var tweets = [Tweet]()
        
        REF_TWEETS_REPLIES.child(tweet.tweetId).observe(.childAdded){ snap in
            guard let dictionary = snap.value as? [String: Any] else { return }
            guard let uid = dictionary["uidUserCreatedTweet"] as? String else { return }
            let tweetId = snap.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion) ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            // Unlike tweet
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue{ (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]){ (err,ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1],withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool)-> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
