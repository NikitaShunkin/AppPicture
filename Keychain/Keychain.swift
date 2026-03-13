import Foundation

final class PinManager {

    static let shared = PinManager()
    private let key = "user_pin"

    func save(pin: String) {
        UserDefaults.standard.set(pin, forKey: key)
    }

    func getPin() -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    var isPinCreated: Bool {
        return getPin() != nil
    }
}
