import UIKit

final class EnterPinViewController: BasePinViewController {

    override func pinCompleted(_ pin: String) {
        if pin == PinManager.shared.getPin() {
            showMainScreen()
        } else {
            self.pin = ""
        }
    }

    private func showMainScreen() {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
