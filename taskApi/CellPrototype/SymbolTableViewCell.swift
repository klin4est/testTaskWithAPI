//
//  SymbolTableViewCell.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 12.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class SymbolTableViewCell: UITableViewCell {

    //MARK: Private Properties
    @IBOutlet private weak var symbolValueLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!

    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Public Methods
    func configure (with symbolStr: Character) {
        symbolValueLabel.text = "'\(symbolStr)'"

        guard let count = CurrentSession.shared.dictSymbols[symbolStr] else { return }
        countLabel.text = "- \(count) times"
    }
}
