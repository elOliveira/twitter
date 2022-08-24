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
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let selfUid  = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "uidUserCreatedTweet": selfUid,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "likes":     0,
            "retweets":  0,
            "caption":   caption
        ] as [String : Any]
        //        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)

        let ref = REF_TWEETS.childByAutoId()
        ref.updateChildValues(values) { (error, reference) in
            guard let tweetID = reference.key else { return }
            REF_USER_TWEETS.child(selfUid).updateChildValues([tweetID:1], withCompletionBlock: completion)
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
}
