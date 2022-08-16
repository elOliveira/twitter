//
//  User.swift
//  twiter
//
//  Created by cit on 15/08/22.
//

import Foundation

class User {
    let uid:    String
    let email:  String
    let password: String
    let fullName: String
    let userName: String
    var profileImageUrl: URL?
    
    init(uid:String, dictionary:[String: AnyObject]){
        self.uid = uid
        self.email = dictionary["email"] as? String  ?? ""
        self.password = dictionary["password"] as? String  ?? ""
        self.fullName = dictionary["fullName"] as? String  ?? ""
        self.userName = dictionary["userName"] as? String  ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
        
    }
}
