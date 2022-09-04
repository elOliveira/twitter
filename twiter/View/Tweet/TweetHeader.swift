//
//  TweetHeader.swift
//  twiter
//
//  Created by cit on 27/08/22.
//

import Foundation
import UIKit

protocol  TweetHeaderDelegate: class {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    // MARK: - Properties
    
     var tweet: Tweet? {
        didSet{ configure() }
    }
    weak var delegate: TweetHeaderDelegate?
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Eliasjan Luiz"
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "eloBoladao"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Some test caption from spiderman for now"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "06:33 PM - 10/01/2022"
        return label
    }()
    
    private lazy var optionsButton:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
       let view = UIView()
        
        let dividier1 = UIView()
        dividier1.backgroundColor = .systemGroupedBackground
        
        view.addSubview(dividier1)
        dividier1.anchor(
            top:view.topAnchor,
            left:view.leftAnchor,
            right:view.rightAnchor,
            paddingLeft:8,
            height: 1.0
        )
        let stack = UIStackView(arrangedSubviews: [retweetsLabel,likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(
            left: view.leftAnchor,
            paddingLeft: 16
        )
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        
        view.addSubview(divider2)
        divider2.anchor(
            left: view.leftAnchor,
            bottom:view.bottomAnchor,
            right:view.rightAnchor,
            paddingLeft: 8,
            height:1.0
        )
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Selectors

    @objc func handleProfileImageTapped(){
        print("handleProfileImage")
    }
    @objc func showActionSheet(){
        delegate?.showActionSheet()
    }
    
    @objc func handleCommentTapped(){
        print("handleCommentTapped")
    }
    
    @objc func handleRetweetTapped(){
        print("handleRetweetTapped")
    }
    
    @objc func handleLikeTapped(){
        print("handleLikeTapped")
    }
    
    @objc func handleShareTapped(){
        print("handleShareTapped")
    }
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureUI(){
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
            labelStack.axis = .vertical
            labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,labelStack])
            stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(
            top:topAnchor,
            left:leftAnchor,
            paddingTop:16,
            paddingLeft:16
        )
        
        addSubview(captionLabel)
        captionLabel.anchor(
            top:stack.bottomAnchor,
            left:leftAnchor,
            right:rightAnchor,
            paddingTop:12,
            paddingLeft:16,
            paddingRight:16
        )
        
        addSubview(dateLabel)
        dateLabel.anchor(
            top:captionLabel.bottomAnchor,
            left:leftAnchor,
            paddingTop:20,
            paddingLeft:16
        )
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right:rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(
            top:dateLabel.bottomAnchor,
            left:leftAnchor,
            right:rightAnchor,
            paddingTop: 12,
            height: 40
        )
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top:statsView.bottomAnchor, paddingTop: 16)
        
    }
    // MARK: - Helpers
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configure(){
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel (tweet: tweet)
        
        captionLabel.text = viewModel.tweet.caption
        fullnameLabel.text = viewModel.tweet.user.fullName
        usernameLabel.text = viewModel.userNameText
        dateLabel.text = viewModel.headerTimestamp
        likesLabel.attributedText = viewModel.likesAttributedString
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
