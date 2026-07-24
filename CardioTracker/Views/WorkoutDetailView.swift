import SwiftUI

@available(iOS 16.0, *)
struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: workoutIcon(workout.type))
                            .font(.title)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.type)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(workout.intensity)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(intensityColor(workout.intensity).opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Main Metrics
                VStack(spacing: 12) {
                    HStack(spacing: 0) {
                        MetricCard(
                            title: "Duration",
                            value: "\(workout.durationInMinutes)",
                            unit: "min",
                            icon: "clock.fill",
                            color: .blue
                        )
                        
                        MetricCard(
                            title: "Distance",
                            value: String(format: "%.2f", workout.distance),
                            unit: "km",
                            icon: "mappin.circle.fill",
                            color: .green
                        )
                    }
                    
                    HStack(spacing: 0) {
                        MetricCard(
                            title: "Avg Heart Rate",
                            value: "\(workout.avgHeartRate)",
                            unit: "bpm",
                            icon: "heart.fill",
                            color: .red
                        )
                        
                        MetricCard(
                            title: "Max Heart Rate",
                            value: "\(workout.maxHeartRate)",
                            unit: "bpm",
                            icon: "heart.slash.fill",
                            color: .orange
                        )
                    }
                }
                
                // Additional Info
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "Calories Burned", value: "\(workout.caloriesBurned) kcal", icon: "flame.fill", color: .orange)
                    InfoRow(label: "Average Speed", value: String(format: "%.2f", workout.averageSpeed) + " km/h", icon: "speedometer", color: .purple)
                    
                    if !workout.notes.isEmpty {
                        InfoRow(label: "Notes", value: workout.notes, icon: "note.text", color: .gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
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

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
    }
}

#Preview {
    WorkoutDetailView(workout: Workout(
        type: "Running",
        duration: 1800,
        distance: 5.0,
        avgHeartRate: 150,
        maxHeartRate: 180,
        caloriesBurned: 300,
        intensity: "High",
        notes: "Great run!"
    ))
}
