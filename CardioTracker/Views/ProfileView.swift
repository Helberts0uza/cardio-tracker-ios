import SwiftUI

@available(iOS 16.0, *)
struct ProfileView: View {
    @ObservedObject var userVM: UserViewModel
    @State private var isEditing = false
    @State private var editName = ""
    @State private var editAge = 0
    @State private var editWeight = 0.0
    @State private var editHeight = 0
    @State private var editGender = "Male"
    @State private var editMaxHR = 0
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = userVM.user {
                        // Profile Header
                        VStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.red)
                            
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Age: \(user.age) • Height: \(user.height)cm")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Health Metrics
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Weight")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(String(format: "%.1f", user.weight))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("kg")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("BMI")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(String(format: "%.1f", user.bmi))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text(user.bmiCategory)
                                        .font(.caption2)
                                        .foregroundColor(bmiColor(user.bmiCategory))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Max HR")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(user.maxHeartRate)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("bpm")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        // Gender Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender")
                                .font(.headline)
                            Text(user.gender)
                                .font(.body)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Edit Button
                        Button(action: startEditing) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profile")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isEditing) {
                EditProfileView(userVM: userVM, isPresented: $isEditing)
            }
        }
    }
    
    func startEditing() {
        if let user = userVM.user {
            editName = user.name
            editAge = user.age
            editWeight = user.weight
            editHeight = user.height
            editGender = user.gender
            editMaxHR = user.maxHeartRate
        }
        isEditing = true
    }
    
    func bmiColor(_ category: String) -> Color {
        switch category {
        case "Normal":
            return .green
        case "Underweight":
            return .blue
        case "Overweight":
            return .orange
        case "Obese":
            return .red
        default:
            return .gray
        }
    }
}

struct EditProfileView: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var age = 0
    @State private var weight = 0.0
    @State private var height = 0
    @State private var gender = "Male"
    @State private var maxHR = 0
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 1...120)
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
                
                Section("Physical Metrics") {
                    Stepper("Height: \(height) cm", value: $height, in: 100...250)
                    Stepper("Weight: \(String(format: "%.1f", weight)) kg", value: $weight, in: 30...200, step: 0.5)
                }
                
                Section("Heart Rate") {
                    Stepper("Max Heart Rate: \(maxHR) bpm", value: $maxHR, in: 100...230)
                }
                
                Button(action: saveProfile) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let user = userVM.user {
                    name = user.name
                    age = user.age
                    weight = user.weight
                    height = user.height
                    gender = user.gender
                    maxHR = user.maxHeartRate
                }
            }
        }
    }
    
    func saveProfile() {
        userVM.updateUser(name: name, age: age, weight: weight, height: height, gender: gender, maxHeartRate: maxHR)
        isPresented = false
    }
}

#Preview {
    ProfileView(userVM: UserViewModel())
}
