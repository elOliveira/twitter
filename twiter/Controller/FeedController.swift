//
//  FeedController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {

    // MARK: - Propertyes
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API

    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
            self.checkIfUserLikedTweets(self.tweets)
        }
    }
    // MARK: - Helpers

    func configureUi() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton(){
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl,completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    func checkIfUserLikedTweets(_ tweets: [Tweet]){
        for(index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                self.tweets[index].didLike = true
            }
        }
    }

}
// MARK: - UICollectionViewDelegate/DataSource

extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet  = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweetControler = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(tweetControler, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}
// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { (err,ref) in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // apenas vai emitir a notificacao se for para dar follow
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        let uploadController = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: uploadController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        
        let profileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
