import Foundation

@available(iOS 16.0, *)
struct Workout: Identifiable, Codable {
    var id: String = UUID().uuidString
    var date: Date
    var type: String // running, cycling, walking, cardio, other
    var duration: Int // seconds
    var distance: Double // km
    var avgHeartRate: Int // bpm
    var maxHeartRate: Int // bpm
    var caloriesBurned: Int
    var intensity: String // low, moderate, high
    var notes: String
    var createdAt: Date
    
    init(type: String, duration: Int, distance: Double, avgHeartRate: Int, maxHeartRate: Int, caloriesBurned: Int, intensity: String, notes: String = "") {
        self.type = type
        self.duration = duration
        self.distance = distance
        self.avgHeartRate = avgHeartRate
        self.maxHeartRate = maxHeartRate
        self.caloriesBurned = caloriesBurned
        self.intensity = intensity
        self.notes = notes
        self.date = Date()
        self.createdAt = Date()
    }
    
    var durationInMinutes: Int {
        duration / 60
    }
    
    var averageSpeed: Double {
        guard duration > 0 else { return 0 }
        return (distance * 3600) / Double(duration)
    }
}
