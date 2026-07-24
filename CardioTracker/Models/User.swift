import Foundation

@available(iOS 16.0, *)
struct User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var age: Int
    var weight: Double // kg
    var height: Int // cm
    var gender: String // male, female, other
    var maxHeartRate: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, age: Int, weight: Double, height: Int, gender: String, maxHeartRate: Int) {
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
        self.maxHeartRate = maxHeartRate
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var bmi: Double {
        let heightInMeters = Double(height) / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    var bmiCategory: String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
}
