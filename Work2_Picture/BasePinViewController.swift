import UIKit

class BasePinViewController: UIViewController {

    var pin = "" {
        didSet {
            updateDots()
            if pin.count == 4 {
                pinCompleted(pin)
            }
        }
    }

    private var dotViews: [UIView] = []
    private let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDots()
        setupTextField()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    private func setupDots() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<4 {
            let dot = UIView()
            dot.layer.cornerRadius = 10
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.black.cgColor
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 20).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 20).isActive = true

            dotViews.append(dot)
            stack.addArrangedSubview(dot)
        }

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTextField() {
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.textColor = .clear

        view.addSubview(textField)

        textField.widthAnchor.constraint(equalToConstant: 0).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 0).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func updateDots() {
        for (index, dot) in dotViews.enumerated() {
            dot.backgroundColor = index < pin.count ? .black : .clear
        }
    }

    func pinCompleted(_ pin: String) {
    }
}

extension BasePinViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let currentText = textField.text else { return false }

        let updatedText = (currentText as NSString)
            .replacingCharacters(in: range, with: string)

        if updatedText.count > 4 { return false }

        pin = updatedText
        textField.text = updatedText

        return false
    }
}
