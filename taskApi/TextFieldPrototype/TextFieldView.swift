//
//  TextFieldView.swift
//  taskApi
//
//  Created by Stanislav Astakhov on 10.02.2018.
//  Copyright © 2018 Stanislav Astakhov. All rights reserved.
//

import UIKit

class TextFieldView: UIView {
    // MARK: Private Properties
    @IBOutlet private weak var defaultTextField: UITextField!

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    //MARK: Class Methods
    class func instanceFromNib() -> TextFieldView? {
        guard let textFieldView = UINib(nibName: "TextFieldView",
                                        bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? TextFieldView
            else { return nil }

        return textFieldView
    }

    //MARK: Private Methods
    private func setupUI() {
        defaultTextField.textColor = UIColor.additionalGray
    }

    //MARK: Public Methods
    func setPlaceHolder(with name: String) {
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.additionalGrayTransparent
        ]
        
        defaultTextField.attributedPlaceholder = NSAttributedString(string: name, attributes: attributes)
    }

    func setSecureTextEnry(enable: Bool) {
        defaultTextField.isSecureTextEntry = enable
    }

    func returnText() -> String? {
        return defaultTextField.text
    }
}

