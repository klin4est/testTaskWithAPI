//
//  StartViewController.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 12.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    //MARK: Private Properties
    @IBOutlet private weak var getTextButton: UIButton!

    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkLoginInfo()
    }

    //MARK: Private Methods
    private func checkLoginInfo() {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: "taskApiAccessToken"),
            let name = defaults.string(forKey: "taskApiName"),
            let email = defaults.string(forKey: "taskApiEmail"),
            let password = defaults.string(forKey: "taskApiPassword") {

            CurrentSession.shared.accessToken = accessToken
            CurrentSession.shared.name = name
            CurrentSession.shared.email = email
            CurrentSession.shared.password = password

        } else {
            performSegue(withIdentifier: "showLoginView", sender: nil)
        }
    }

    //MARK: Actions
    @IBAction func getTextFromApi(_ sender: UIButton) {
        getInfoFromApi(from: "https://apiecho.cf/api/get/text/")
    }

    private func getInfoFromApi(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(CurrentSession.shared.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "error", message: "No data", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alert.addAction(okButton)
                self?.present(alert, animated: true, completion: nil)

                return
            }

            if let data = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let json = responseJSON as? [String: Any] {
                    if let dataString = json["data"] as? String {
                        CurrentSession.shared.dictSymbols = dataString.reduce([:]) { (dict, count) -> Dictionary<Character,Int> in
                            var dict = dict
                            let i = dict[count] ?? 0
                            dict[count] = i+1
                            return dict
                        }
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: "showStatisticView", sender: nil)
                        }
                    }
                }
            }
            }
        )
        task.resume()
    }
}
