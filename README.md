# Cardio Tracker iOS

Um app nativo de rastreamento cardiovascular para iPhone desenvolvido em Swift e SwiftUI.

## Features

- 📊 Dashboard com frequência cardíaca em tempo real
- 💪 Histórico completo de workouts
- 📈 Gráficos semanais e mensais
- 👤 Perfil do usuário editável
- 💾 Dados salvos localmente com CoreData
- 🎯 Zonas de frequência cardíaca
- 📱 Suporte a iPhone 12+

## Requisitos

- Xcode 15+
- iOS 16+
- Swift 5.9+

## Como usar

1. Clone o repositório
2. Abra `CardioTracker.xcodeproj` no Xcode
3. Selecione seu device/simulator
4. Press Cmd+R para rodar

## Estrutura

```
CardioTracker/
├── Models/
│   ├── User.swift
│   ├── Workout.swift
│   └── HeartRateData.swift
├── ViewModels/
│   ├── UserViewModel.swift
│   ├── WorkoutViewModel.swift
│   └── AnalyticsViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── HomeView.swift
│   ├── WorkoutListView.swift
│   ├── WorkoutDetailView.swift
│   ├── AnalyticsView.swift
│   └── ProfileView.swift
├── Utilities/
│   ├── HeartRateCalculations.swift
│   └── DateFormats.swift
└── CardioTrackerApp.swift
```

## Author

Helbert Souza
