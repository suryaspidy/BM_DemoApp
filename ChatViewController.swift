//
//  ChatViewController.swift
//  CustomerIssue_BM
//
//  Created by surya-15302 on 29/03/25.
//

import UIKit

class ChatViewController: UIViewController {

    private let mainStack = UIStackView()
    private let navBar = UIView()
    private let chatArea = UIView()
    private let inputContainer = UIView()
    private let spacerView = UIView()

    private let collectionView: UICollectionView = {
        let layout = ChatFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.systemGroupedBackground
        collection.transform = CGAffineTransform(scaleX: 1, y: -1)
        return collection
    }()

    private let textField = UITextField()
    private let sendButton = UIButton()
    private var spacerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupKeyboardObservers()
        view.backgroundColor = UIColor.systemGroupedBackground
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupLayout() {
        mainStack.axis = .vertical
        mainStack.spacing = 0
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // ✅ Safe area fix
        ])

        // NavBar
        navBar.backgroundColor = .white
        navBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let title = UILabel()
        title.text = "💬 Chat with us"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.textColor = .label
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        navBar.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: navBar.centerYAnchor)
        ])
        mainStack.addArrangedSubview(navBar)

        // Chat Area
        chatArea.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: "ChatCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: chatArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: chatArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: chatArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatArea.bottomAnchor)
        ])
        mainStack.addArrangedSubview(chatArea)

        // Input
        inputContainer.backgroundColor = .white
        inputContainer.layer.borderColor = UIColor.lightGray.cgColor
        inputContainer.layer.borderWidth = 0.5
        inputContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        mainStack.addArrangedSubview(inputContainer)

        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 18
        textField.layer.masksToBounds = true
        textField.placeholder = "Type a message..."
        textField.font = .systemFont(ofSize: 16)
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true // ✅ FIXED SQUASHING

        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .systemBlue
        sendButton.backgroundColor = UIColor.systemGray5
        sendButton.layer.cornerRadius = 16
        sendButton.layer.shadowOpacity = 0.1
        sendButton.layer.shadowRadius = 3
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        [textField, sendButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
        }

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            textField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 32),
            sendButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        // Spacer
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerHeightConstraint = spacerView.heightAnchor.constraint(equalToConstant: 0)
        spacerHeightConstraint.isActive = true
        mainStack.addArrangedSubview(spacerView)
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0) // #F2F2F7

    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        spacerHeightConstraint.constant = frame.height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        spacerHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }

    @objc private func sendTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.sendButton.transform = .identity
            }
        }
        print("Message sent: \(textField.text ?? "")")
        textField.text = ""
    }
}

// MARK: - CollectionView
extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let isUser = indexPath.item % 2 == 0
        cell.configure(text: isUser ? "Hi!" : "Thanks! 😊", fromUser: isUser)
        return cell
    }
}

// MARK: - Chat Cell
class ChatCell: UICollectionViewCell {

    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        bubbleView.layer.cornerRadius = 18
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 280)
        ])

        leftConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        rightConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
    }

    func configure(text: String, fromUser: Bool) {
        messageLabel.text = text

        if fromUser {
            bubbleView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            bubbleView.layer.shadowColor = UIColor.black.cgColor
            bubbleView.layer.shadowOpacity = 0.1
            bubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
            bubbleView.layer.shadowRadius = 4
        } else {
            // Softer gray bubble with contrast against light chat bg
            bubbleView.backgroundColor = UIColor.systemBackground
            messageLabel.textColor = .label
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            bubbleView.layer.shadowColor = UIColor.gray.cgColor
            bubbleView.layer.shadowOpacity = 0.05
            bubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
            bubbleView.layer.shadowRadius = 2
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom Layout
class ChatFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .vertical
        minimumLineSpacing = 12
        sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach { attr in
            attr.bounds.size.width = collectionView?.bounds.width ?? UIScreen.main.bounds.width
        }
        return attributes
    }
}

// MARK: - TextField Padding Extension
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
