//
//  NotificationsController.swift
//  twiter
//
//  Created by elo on 28/05/22.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    // MARK: - Propertyes
    private var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        

        tableView.reloadData()
    }
    // MARK: - Selectors
    
    @objc func handleRefresh(){
        fetchNotifications()
    }

    // MARK: - API
    fileprivate func checkIfUserIsFollowed(_ notifications: [Notification]) {
        for(index, notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user

                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFolowed =  isFollowed
                }
            }
        }
    }
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed(notifications)
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    func configureUi() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControll = UIRefreshControl()
        tableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

}
// MARK: - NotificationsDataSource

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetId else { return }
        
        TweetService.shared.fetchTweet(withTweetId: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate
extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFolowed {
            UserService.shared.unfollowUser(uid: user.uid) {(err,ref) in
                cell.notification?.user.isFolowed = false
                self.tableView.reloadData()

            }
        } else {
            UserService.shared.followUser(uid: user.uid) {(err,ref) in
                cell.notification?.user.isFolowed = true
                self.tableView.reloadData()
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
