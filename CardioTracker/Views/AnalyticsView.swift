import SwiftUI

@available(iOS 16.0, *)
struct AnalyticsView: View {
    @ObservedObject var workoutVM: WorkoutViewModel
    @StateObject private var analyticsVM: AnalyticsViewModel
    
    init(workoutVM: WorkoutViewModel) {
        self.workoutVM = workoutVM
        _analyticsVM = StateObject(wrappedValue: AnalyticsViewModel(workouts: workoutVM.workouts))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Weekly Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Week")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Workouts")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(workoutVM.workoutsThisWeek().count)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Calories")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(workoutVM.totalCaloriesThisWeek())")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Avg HR")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(workoutVM.averageHeartRateThisWeek())")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Weekly Calories Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Calories by Day")
                            .font(.headline)
                        
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(analyticsVM.weeklyStats, id: \.day) { stat in
                                VStack(spacing: 8) {
                                    let maxCalories = analyticsVM.weeklyStats.map { $0.calories }.max() ?? 1
                                    let percentage = maxCalories > 0 ? CGFloat(stat.calories) / CGFloat(maxCalories) : 0
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.orange.opacity(0.7))
                                        .frame(height: max(10, 150 * percentage))
                                    
                                    Text(stat.day)
                                        .font(.caption2)
                                    
                                    Text("\(stat.calories)")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    // Heart Rate Trend
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Heart Rate Trend")
                            .font(.headline)
                        
                        if analyticsVM.heartRateData.isEmpty {
                            Text("No data available")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack(spacing: 8) {
                                ForEach(analyticsVM.heartRateData, id: \.date) { data in
                                    HStack {
                                        Text(data.date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .frame(width: 50, alignment: .leading)
                                        
                                        let maxHR = analyticsVM.heartRateData.map { $0.hr }.max() ?? 150
                                        let percentage = CGFloat(data.hr) / CGFloat(maxHR)
                                        
                                        GeometryReader { geometry in
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(hrColor(data.hr))
                                                .frame(width: geometry.size.width * percentage)
                                        }
                                        .frame(height: 24)
                                        
                                        Text("\(data.hr) bpm")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 60, alignment: .trailing)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    
                    // Monthly Stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("This Month")
                            .font(.headline)
                        
                        let monthWorkouts = workoutVM.workoutsThisMonth()
                        
                        HStack(spacing: 12) {
                            InfoCard(label: "Total Distance", value: String(format: "%.1f", workoutVM.totalDistanceThisMonth()), unit: "km")
                            
                            InfoCard(label: "Workouts", value: "\(monthWorkouts.count)", unit: "done")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func hrColor(_ hr: Int) -> Color {
        switch hr {
        case ..<100:
            return .green
        case 100..<140:
            return .blue
        case 140..<170:
            return .orange
        default:
            return .red
        }
    }
}

struct InfoCard: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    AnalyticsView(workoutVM: WorkoutViewModel())
}
