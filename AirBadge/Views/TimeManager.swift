//
//  TimeManager.swift
//  AirBadge
//
//  Created by Muhammadjon on 12/18/24.
//

import Foundation
import LocalAuthentication

class TimeManager: ObservableObject {
    @Published var isTappedIn: Bool = false
    @Published var timeSpentToday: String = "00:00:00"
    @Published var weeklyData: [String: Double] = [:] // Tracks hours spent for each day of the week
    @Published var hasTappedToday: Bool = false // Ensures single tap-in/out per day
    
    private var tapInTime: Date? // Stores the time when user taps in
    private var timer: Timer? // Timer object to update elapsed time
    
    init() {
        loadWeeklyData()
        checkIfTappedToday()
    }
    
    func tapInWithFaceID(completion: @escaping (Bool) -> Void) {
        authenticateUser { success in
            DispatchQueue.main.async {
                if success {
                    self.tapIn()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Tap in with Face ID") { success, _ in
                completion(success)
            }
        } else {
            completion(false)
        }
    }
    
    func tapIn() {
        guard !hasTappedToday else { return } // Ensure no second tap-in
        isTappedIn = true
        hasTappedToday = true
        tapInTime = Date()
        startTimer()
    }
    
    func tapOut() {
        guard isTappedIn else { return }
        isTappedIn = false
        stopTimer()
        
        if let tapInTime = tapInTime {
            let elapsedTime = Date().timeIntervalSince(tapInTime)
            updateTimeSpentToday(elapsedTime)
            saveWeeklyData()
        }
        tapInTime = nil
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateElapsedTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateElapsedTime() {
        if let tapInTime = tapInTime {
            let elapsedTime = Date().timeIntervalSince(tapInTime)
            timeSpentToday = formatTime(elapsedTime)
        }
    }
    
    private func updateTimeSpentToday(_ additionalTime: TimeInterval) {
        let today = getCurrentDay()
        let previousTime = weeklyData[today] ?? 0
        let totalTime = previousTime + (additionalTime / 3600) // Convert seconds to hours
        weeklyData[today] = totalTime
        timeSpentToday = formatTime(totalTime * 3600)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hrs = Int(seconds) / 3600
        let mins = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    private func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: Date())
    }
    
    private func saveWeeklyData() {
        if let encoded = try? JSONEncoder().encode(weeklyData) {
            UserDefaults.standard.set(encoded, forKey: "weeklyData")
            UserDefaults.standard.set(hasTappedToday, forKey: "hasTappedToday")
        }
    }
    
    private func loadWeeklyData() {
        if let savedData = UserDefaults.standard.data(forKey: "weeklyData"),
           let decoded = try? JSONDecoder().decode([String: Double].self, from: savedData) {
            weeklyData = decoded
        } else {
            weeklyData = ["Mon": 0, "Tue": 0, "Wed": 0, "Thu": 0, "Fri": 0, "Sat": 0, "Sun": 0]
        }
    }
    
    private func checkIfTappedToday() {
        let lastDay = UserDefaults.standard.string(forKey: "lastTappedDay") ?? ""
        let today = getCurrentDay()
        
        if lastDay == today {
            hasTappedToday = UserDefaults.standard.bool(forKey: "hasTappedToday")
        } else {
            hasTappedToday = false // Reset for new day
            UserDefaults.standard.set(today, forKey: "lastTappedDay")
        }
    }
}
