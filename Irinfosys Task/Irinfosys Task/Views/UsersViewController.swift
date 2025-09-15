//
//  UsersViewController.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import UIKit

final class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: UsersViewModel!
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        tableView.dataSource = self
        tableView.delegate = self
        activityIndicator.hidesWhenStopped = true
        
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")

        let api = APIService(httpClient: HTTPClient(), tokenStore: KeychainTokenStore())
        viewModel = UsersViewModel(api: api)
        viewModel.delegate = self
        
        viewModel.fetchUsers()
    }
    @IBAction func logout(_ sender: UIButton) {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.logout()
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
        let user = users[indexPath.row]
        if let imageUrl = URL(string: user.avatar ?? "") {
            cell.avatarImageView.loadImage(from: imageUrl)
        }
        cell.fullNameLabel?.text = user.fullName
        cell.emailLabel?.text = user.email
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else { return }
        detailVC.user = user
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension UsersViewController: UsersViewModelDelegate {
    func usersFetchDidStart() {
        activityIndicator.startAnimating()
    }

    func usersFetchDidSucceed(users: [User]) {
        activityIndicator.stopAnimating()
        self.users = users
        tableView.reloadData()
    }

    func usersFetchDidFail(error: String) {
        activityIndicator.stopAnimating()
        showAlert(title: "Error", message: "\(error)")
    }
}
