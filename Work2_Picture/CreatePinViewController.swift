import UIKit

final class CreatePinViewController: BasePinViewController {

    override func pinCompleted(_ pin: String) {
        PinManager.shared.save(pin: pin)

        let enterViewController = EnterPinViewController()
        enterViewController.modalPresentationStyle = .fullScreen
        present(enterViewController, animated: true)
    }
}
