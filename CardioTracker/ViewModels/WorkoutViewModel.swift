import Foundation

@available(iOS 16.0, *)
class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    
    private let userDefaults = UserDefaults.standard
    private let workoutKey = "cardio_workouts"
    
    init() {
        loadWorkouts()
        if workouts.isEmpty {
            generateSampleWorkouts()
        }
    }
    
    func loadWorkouts() {
        if let data = userDefaults.data(forKey: workoutKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            self.workouts = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutKey)
        }
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.insert(workout, at: 0)
        saveWorkouts()
    }
    
    func deleteWorkout(_ id: String) {
        workouts.removeAll { $0.id == id }
        saveWorkouts()
    }
    
    func generateSampleWorkouts() {
        let today = Date()
        var sampleWorkouts: [Workout] = []
        
        for i in 0..<14 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: today) ?? today
            
            if Int.random(in: 0...100) > 30 {
                let types = ["Running", "Cycling", "Walking", "Cardio", "Swimming"]
                let type = types.randomElement() ?? "Cardio"
                let duration = Int.random(in: 600...3600)
                let distance = Double(Int.random(in: 5...20))
                let avgHR = Int.random(in: 100...160)
                let maxHR = avgHR + Int.random(in: 10...40)
                let calories = Int(Double(avgHR) * Double(duration) / 60 * 0.1)
                let intensity = avgHR > 140 ? "High" : avgHR > 120 ? "Moderate" : "Low"
                
                var workout = Workout(
                    type: type,
                    duration: duration,
                    distance: distance,
                    avgHeartRate: avgHR,
                    maxHeartRate: maxHR,
                    caloriesBurned: calories,
                    intensity: intensity,
                    notes: "\(type) session"
                )
                workout.date = date
                sampleWorkouts.append(workout)
            }
        }
        
        workouts = sampleWorkouts
        saveWorkouts()
    }
    
    func workoutsThisWeek() -> [Workout] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return workouts.filter { $0.date >= weekAgo }
    }
    
    func workoutsThisMonth() -> [Workout] {
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return workouts.filter { $0.date >= monthAgo }
    }
    
    func totalCaloriesThisWeek() -> Int {
        workoutsThisWeek().reduce(0) { $0 + $1.caloriesBurned }
    }
    
    func averageHeartRateThisWeek() -> Int {
        let weekWorkouts = workoutsThisWeek()
        guard !weekWorkouts.isEmpty else { return 0 }
        let sum = weekWorkouts.reduce(0) { $0 + $1.avgHeartRate }
        return sum / weekWorkouts.count
    }
    
    func totalDistanceThisMonth() -> Double {
        workoutsThisMonth().reduce(0) { $0 + $1.distance }
    }
}
