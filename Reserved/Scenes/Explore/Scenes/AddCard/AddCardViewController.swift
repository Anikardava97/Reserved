//
//  AddCardViewController.swift
//  Reserved
//
//  Created by Ani's Mac on 09.02.24.
//

import UIKit
import Lottie

protocol AddCardViewControllerDelegate: AnyObject {
    func didAddNewCard()
}

final class AddCardViewController: UIViewController {
    // MARK: - Methods
    var creditCardManager: CreditCardManager!
    private var animationView: LottieAnimationView!
    var cardAddedSuccessfully: (() -> Void)?
    weak var delegate: AddCardViewControllerDelegate?

    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add payment card"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "Name on card", keyboardType: .alphabet, icon: UIImage(systemName: "person"))
        return textField
    }()
    
    private let cardNumberTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "1234 1234 1234 1234", keyboardType: .numberPad, icon: UIImage(systemName: "creditcard"))
        return textField
    }()
    
    private lazy var dateAndCvcStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [expiryDateTextField, cvcTextField])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let expiryDateTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "MM/YY", keyboardType: .numberPad, icon: UIImage(systemName: "calendar"))
        return textField
    }()
    
    private let cvcTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "CVC", keyboardType: .numberPad, icon: UIImage(systemName: "creditcard.and.123"))
        return textField
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = MainButtonComponent(text: "Add card", textColor: .white, backgroundColor: .customAccentColor)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - ViewLifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        setupTextFieldTags()
        setupTextFieldDelegates()
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupTapGestureRecogniser()
        setupAddCardButtonAction()
        updateAddCardButtonState()
    }
    
    private func setupTextFieldTags() {
        nameTextField.tag = 0
        cardNumberTextField.tag = 1
        expiryDateTextField.tag = 2
        cvcTextField.tag = 3
    }
    
    private func setupTextFieldDelegates() {
        nameTextField.delegate = self
        cardNumberTextField.delegate = self
        expiryDateTextField.delegate = self
        cvcTextField.delegate = self
        
        [nameTextField, cardNumberTextField, expiryDateTextField, cvcTextField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    private func allFieldsAreValid() -> Bool {
        let nameIsValid = nameTextField.text?.contains(" ") ?? false && !nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let cardNumberIsValid = cardNumberTextField.text?.isEmpty == false && cardNumberTextField.text?.replacingOccurrences(of: " ", with: "").count == 16
        let expiryDateIsValid = expiryDateTextField.text?.isEmpty == false && expiryDateTextField.text?.replacingOccurrences(of: "/", with: "").count == 4
        let cvcIsValid = cvcTextField.text?.isEmpty == false &&
        cvcTextField.text!.count == 3
        
        return nameIsValid && cardNumberIsValid && expiryDateIsValid && cvcIsValid
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(cardNumberTextField)
        mainStackView.addArrangedSubview(dateAndCvcStackView)
        mainStackView.addArrangedSubview(addCardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            expiryDateTextField.heightAnchor.constraint(equalToConstant: 48),
            cvcTextField.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupTapGestureRecogniser() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAddCardButtonAction() {
        addCardButton.addTarget(self, action: #selector(addCardButtonDidTap), for: .touchUpInside)
    }
    
    private func updateAddCardButtonState() {
        let isValid = allFieldsAreValid()
        addCardButton.isEnabled = isValid
        
        addCardButton.backgroundColor = isValid ? .customAccentColor : .customAccentColor.withAlphaComponent(0.6)
        addCardButton.setTitleColor(isValid ? .white : .gray, for: .normal)
    }
    
    private func setupAnimationView() {
        navigationItem.setHidesBackButton(true, animated: false)
        mainStackView.isHidden = true
        
        animationView = .init(name: "Animation - 1707465055026")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300),
        ])
        animationView.play()
        
        let processingLabel = UILabel()
        processingLabel.text = "Processing card..."
        processingLabel.textColor = .white
        processingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        processingLabel.textAlignment = .center
        processingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(processingLabel)
        
        NSLayoutConstraint.activate([
            processingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            processingLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: -70)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            self?.animationView.isHidden = true
            processingLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateAddCardButtonState()
    }
    
    @objc func addCardButtonDidTap() {
        guard allFieldsAreValid() else { return }
        
        let newCard = CreditCard(
            name: nameTextField.text ?? "",
            number: cardNumberTextField.text?.replacingOccurrences(of: " ", with: "") ?? "",
            expirationDate: expiryDateTextField.text ?? "",
            cvc: cvcTextField.text ?? ""
        )
        creditCardManager.addCard(newCard)
        delegate?.didAddNewCard()
        
        setupAnimationView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - TextFieldTypes
enum TextFieldType {
    case name
    case cardNumber
    case expiryDate
    case cvc
}

// MARK: - Extension: TextField Validations
extension AddCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
            
        case 1:
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let numericText = replacementText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let maxLength = 16
            if numericText.count > maxLength { return false }
            var formattedText = ""
            for (index, character) in numericText.enumerated() {
                if index % 4 == 0 && index > 0 { formattedText += " " }
                formattedText.append(character)
            }
            textField.text = formattedText
            return false
            
        case 2:
            let fullText = (textField.text ?? "") as NSString
            let updatedText = fullText.replacingCharacters(in: range, with: string)
            
            guard string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil, updatedText.count <= 5 else {
                return false
            }
            
            var newText = updatedText.replacingOccurrences(of: "/", with: "")
            if newText.count > 2 {
                newText = String(newText.prefix(2)) + "/" + newText.dropFirst(2)
            }
            if newText.count >= 5 {
                let yearString = String(newText.suffix(2))
                let currentYear = Calendar.current.component(.year, from: Date()) % 100
                if let year = Int(yearString), year < currentYear {
                    return false
                }
            }
            if newText.count >= 2 {
                let monthString = String(newText.prefix(2))
                if let month = Int(monthString), month > 12 || month == 0 {
                    return false
                }
            }
            textField.text = newText
            return false
            
        case 3:
            let currentString = textField.text ?? ""
            let newString = (currentString as NSString).replacingCharacters(in: range, with: string)
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && newString.count <= 3
            
        default:
            return true
        }
    }
}
