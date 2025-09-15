//
//  LoginViewController.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//


import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenStore = KeychainTokenStore()
        let api = APIService(httpClient: HTTPClient(), tokenStore: tokenStore)
        viewModel = LoginViewModel(api: api)
        viewModel.delegate = self
        activityIndicator.hidesWhenStopped = true
    }

    @IBAction func loginTapped(_ sender: UIButton) {
//        Task { @MainActor in
//            viewModel.email = emailField.text ?? "eve.holt@reqres.in"
//            viewModel.password = passwordField.text ?? "cityslicka"
//            await viewModel.login()
//        }
        Task { @MainActor in
                // Get text from text fields
                viewModel.email = emailField.text ?? "eve.holt@reqres.in"
                viewModel.password = passwordField.text ?? "cityslicka"
                
                // Call async login function
                await viewModel.login()
            }
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func loginDidStart() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    func loginDidSucceed() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            (UIApplication.shared.delegate as? AppDelegate)?.loadHomeScene()
        }
    }
    func loginDidFail(error: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.showAlert(title: "Error!", message: error)
        }
    }
}


// credential
//user-eve.holt@reqres.in
//pass-cityslicka
