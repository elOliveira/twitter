//
//  Constants.swift
//  twiter
//
//  Created by cit on 03/07/22.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let DB_REF = Database.database().reference()

let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let REF_USERS = DB_REF.child("users")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_USER_LIKES = DB_REF.child("user-likes")


let REF_TWEETS = DB_REF.child("tweets")
let REF_TWEETS_REPLIES = DB_REF.child("tweets-replies") // mudar esse tweets para tweet
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
