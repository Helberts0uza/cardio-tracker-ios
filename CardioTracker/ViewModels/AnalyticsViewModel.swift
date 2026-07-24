import Foundation

@available(iOS 16.0, *)
class AnalyticsViewModel: ObservableObject {
    @Published var weeklyStats: [(day: String, calories: Int, workouts: Int)] = []
    @Published var heartRateData: [(date: String, hr: Int)] = []
    
    init(workouts: [Workout]) {
        calculateWeeklyStats(workouts: workouts)
        calculateHeartRateData(workouts: workouts)
    }
    
    func calculateWeeklyStats(workouts: [Workout]) {
        let calendar = Calendar.current
        let today = Date()
        var stats: [(day: String, calories: Int, workouts: Int)] = []
        
        for i in (0..<7).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            let dayWorkouts = workouts.filter { calendar.isDate($0.date, inSameDayAs: date) }
            let calories = dayWorkouts.reduce(0) { $0 + $1.caloriesBurned }
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            
            stats.append((day: dayName, calories: calories, workouts: dayWorkouts.count))
        }
        
        self.weeklyStats = stats
    }
    
    func calculateHeartRateData(workouts: [Workout]) {
        let calendar = Calendar.current
        let today = Date()
        var data: [(date: String, hr: Int)] = []
        
        for i in (0..<14).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            let dayWorkouts = workouts.filter { calendar.isDate($0.date, inSameDayAs: date) }
            
            if !dayWorkouts.isEmpty {
                let avgHR = dayWorkouts.reduce(0) { $0 + $1.avgHeartRate } / dayWorkouts.count
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                data.append((date: formatter.string(from: date), hr: avgHR))
            }
        }
        
        self.heartRateData = data
    }
}
