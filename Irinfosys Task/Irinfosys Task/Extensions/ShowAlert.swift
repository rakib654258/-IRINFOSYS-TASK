//
//  ShowAlert.swift
//  Irinfosys Task
//
//  Created by Abdul Motalab Rakib on 15/9/25.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        okTitle: String = "OK",
        cancelTitle: String? = nil,
        okHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        }
        alert.addAction(okAction)

        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler?()
            }
            alert.addAction(cancelAction)
        }

        present(alert, animated: true, completion: nil)
    }
}
