import SwiftUI

@available(iOS 16.0, *)
struct HomeView: View {
    @ObservedObject var userVM: UserViewModel
    @ObservedObject var workoutVM: WorkoutViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back!")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text(userVM.user?.name ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Heart Rate Card
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text("Heart Rate")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        let avgHR = workoutVM.averageHeartRateThisWeek()
                        HStack(alignment: .bottom, spacing: 4) {
                            Text("\(avgHR)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.red)
                            Text("bpm")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("This Week Avg")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Stats Row
                    HStack(spacing: 12) {
                        StatCard(
                            title: "Calories",
                            value: "\(workoutVM.totalCaloriesThisWeek())",
                            unit: "kcal",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Distance",
                            value: String(format: "%.1f", workoutVM.totalDistanceThisMonth()),
                            unit: "km",
                            icon: "map.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Workouts",
                            value: "\(workoutVM.workoutsThisWeek().count)",
                            unit: "this week",
                            icon: "dumbbell.fill",
                            color: .green
                        )
                    }
                    
                    // Recent Workouts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Workouts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if workoutVM.workouts.isEmpty {
                            Text("No workouts yet")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(workoutVM.workouts.prefix(3)) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutRowView(workout: workout)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Cardio Tracker")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workoutIcon(workout.type))
                .font(.title3)
                .foregroundColor(.red)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type)
                    .fontWeight(.semibold)
                HStack(spacing: 12) {
                    Label("\(workout.durationInMinutes) min", systemImage: "clock")
                    Label(String(format: "%.1f", workout.distance) + " km", systemImage: "mappin")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(workout.avgHeartRate) bpm")
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(workout.intensity)
                    .font(.caption)
                    .foregroundColor(intensityColor(workout.intensity))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    func workoutIcon(_ type: String) -> String {
        switch type.lowercased() {
        case "running":
            return "figure.run"
        case "cycling":
            return "bicycle"
        case "walking":
            return "figure.walk"
        case "swimming":
            return "figure.pool.swim"
        default:
            return "heart.fill"
        }
    }
    
    func intensityColor(_ intensity: String) -> Color {
        switch intensity.lowercased() {
        case "high":
            return .red
        case "moderate":
            return .orange
        default:
            return .green
        }
    }
}

#Preview {
    HomeView(userVM: UserViewModel(), workoutVM: WorkoutViewModel())
}
