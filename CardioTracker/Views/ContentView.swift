import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    @StateObject var userVM = UserViewModel()
    @StateObject var workoutVM = WorkoutViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userVM: userVM, workoutVM: workoutVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            WorkoutListView(workoutVM: workoutVM)
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell.fill")
                }
                .tag(1)
            
            AnalyticsView(workoutVM: workoutVM)
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            ProfileView(userVM: userVM)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.red)
    }
}

#Preview {
    ContentView()
}
