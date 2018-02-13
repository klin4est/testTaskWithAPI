//
//  StatisticViewController.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 12.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Private Properties
    private struct Constants {
        static let SymbolCellIdentifier = "SymbolCellIdentifier"
        static let CountOfSection = 1
    }
    @IBOutlet private weak var symbolsTableView: UITableView!
    private let arrayOfSymbols = Array(CurrentSession.shared.dictSymbols.keys)

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        symbolsTableView.delegate = self
        symbolsTableView.dataSource = self

        symbolsTableView.register(UINib(nibName: "SymbolTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: Constants.SymbolCellIdentifier)
        symbolsTableView.tableFooterView = UIView()
    }

    //MARK: Table view methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SymbolCellIdentifier,
                                                 for: indexPath) as! SymbolTableViewCell
        cell.configure(with: arrayOfSymbols[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrayOfSymbols.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.CountOfSection
    }
}
