//
//  ViewController.swift
//  BM_DemoApp
//
//  Created by surya-15302 on 03/04/25.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements
    private let orgIdTextField = CustomInputView(
        placeholder: "Enter Org ID",
        infoText: "Enter your org ID here"
    )

    private let appIdTextField = CustomInputView(
        placeholder: "Enter App ID",
        infoText: "Enter the app ID here"
    )

    private let domainTextField = CustomInputView(
        placeholder: "Enter Domain",
        infoText: "Enter your domain here"
    )

    private let viewModel = ViewControllerModel()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(submitTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setDefaultValues()
    }
    
    func setDefaultValues() {
        orgIdTextField.textField.text = "857707145"
        appIdTextField.textField.text = "fe62702445b55264806d68614baab0ec"
        domainTextField.textField.text = "https://desk.zoho.com"
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = UIColor.systemGroupedBackground
        title = "Configure BM SDK"

        let stackView = UIStackView(arrangedSubviews: [
            orgIdTextField,
            appIdTextField,
            domainTextField,
            submitButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions

    @objc private func submitTapped() {
        let orgId = orgIdTextField.text
        let flowId = appIdTextField.text
        let domain = domainTextField.text
        self.viewModel.show(orgId: orgId, appId: flowId, domain: domain)
    }
}
