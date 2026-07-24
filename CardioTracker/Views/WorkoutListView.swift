import SwiftUI

@available(iOS 16.0, *)
struct WorkoutListView: View {
    @ObservedObject var workoutVM: WorkoutViewModel
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workoutVM.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        WorkoutListRow(workout: workout)
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        workoutVM.deleteWorkout(workoutVM.workouts[index].id)
                    }
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(workoutVM: workoutVM, isPresented: $showingAddWorkout)
            }
        }
    }
}

struct WorkoutListRow: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workout.type)
                    .fontWeight(.semibold)
                Spacer()
                Text(workout.intensity)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(intensityColor(workout.intensity).opacity(0.2))
                    .cornerRadius(4)
            }
            
            HStack(spacing: 16) {
                Label("\(workout.durationInMinutes) min", systemImage: "clock")
                Label(String(format: "%.1f", workout.distance) + " km", systemImage: "mappin")
                Label("\(workout.avgHeartRate) bpm", systemImage: "heart.fill")
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundColor(.gray)
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

struct AddWorkoutView: View {
    @ObservedObject var workoutVM: WorkoutViewModel
    @Binding var isPresented: Bool
    
    @State private var type = "Running"
    @State private var duration = 30
    @State private var distance = 5.0
    @State private var avgHeartRate = 120
    @State private var maxHeartRate = 150
    @State private var intensity = "Moderate"
    @State private var notes = ""
    
    let types = ["Running", "Cycling", "Walking", "Cardio", "Swimming"]
    let intensities = ["Low", "Moderate", "High"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Workout Details") {
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    
                    Stepper("Duration: \(duration) min", value: $duration, in: 1...300)
                    Stepper("Distance: \(String(format: "%.1f", distance)) km", value: $distance, in: 0.1...100, step: 0.1)
                }
                
                Section("Heart Rate") {
                    Stepper("Avg HR: \(avgHeartRate) bpm", value: $avgHeartRate, in: 50...200)
                    Stepper("Max HR: \(maxHeartRate) bpm", value: $maxHeartRate, in: 50...220)
                }
                
                Section("Additional") {
                    Picker("Intensity", selection: $intensity) {
                        ForEach(intensities, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    
                    TextField("Notes", text: $notes)
                }
                
                Button(action: saveWorkout) {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func saveWorkout() {
        let calories = Int(Double(avgHeartRate) * Double(duration) * 0.1)
        var workout = Workout(
            type: type,
            duration: duration * 60,
            distance: distance,
            avgHeartRate: avgHeartRate,
            maxHeartRate: maxHeartRate,
            caloriesBurned: calories,
            intensity: intensity,
            notes: notes
        )
        
        workoutVM.addWorkout(workout)
        isPresented = false
    }
}

#Preview {
    WorkoutListView(workoutVM: WorkoutViewModel())
}
