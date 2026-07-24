import Foundation

@available(iOS 16.0, *)
class UserViewModel: ObservableObject {
    @Published var user: User?
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "cardio_user"
    
    init() {
        loadUser()
    }
    
    func loadUser() {
        if let data = userDefaults.data(forKey: userKey),
           let decoded = try? JSONDecoder().decode(User.self, from: data) {
            self.user = decoded
        } else {
            // Default user
            self.user = User(name: "John Doe", age: 30, weight: 75, height: 180, gender: "male", maxHeartRate: 190)
        }
    }
    
    func saveUser(_ user: User) {
        self.user = user
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
    
    func updateUser(name: String, age: Int, weight: Double, height: Int, gender: String, maxHeartRate: Int) {
        var updatedUser = User(name: name, age: age, weight: weight, height: height, gender: gender, maxHeartRate: maxHeartRate)
        updatedUser.id = user?.id ?? UUID().uuidString
        updatedUser.createdAt = user?.createdAt ?? Date()
        updatedUser.updatedAt = Date()
        saveUser(updatedUser)
    }
}
