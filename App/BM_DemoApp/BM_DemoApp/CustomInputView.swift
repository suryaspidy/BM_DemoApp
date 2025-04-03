//
//  CustomInputView.swift
//  BM_DemoApp
//
//  Created by surya-15302 on 03/04/25.
//

import UIKit

class CustomInputView: UIView {

    let textField = UITextField()
    private let infoLabel = UILabel()

    var text: String {
        return textField.text ?? ""
    }

    init(placeholder: String, infoText: String) {
        super.init(frame: .zero)
        setupView(placeholder: placeholder, infoText: infoText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(placeholder: String, infoText: String) {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        translatesAutoresizingMaskIntoConstraints = false

        // Info Label Setup
        infoLabel.text = infoText
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.textColor = .darkGray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        // TextField Setup
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)

        // Container stack
        let stack = UIStackView(arrangedSubviews: [infoLabel, textField])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }
}
