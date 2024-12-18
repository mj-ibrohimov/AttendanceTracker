import Foundation

class WeeklyDataManager: ObservableObject {
    @Published var isTappedIn: Bool = false
    @Published var tapInTime: Date? = nil
    @Published var timeSpentToday: String = "0h 0m"
    @Published var weeklyData: [String: Double] = [:]
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadState()
    }
    
    func tapIn() {
        isTappedIn = true
        tapInTime = Date()
        saveState()
    }
    
    func tapOut() {
        guard let tapInTime = tapInTime else { return }
        let tapOutTime = Date()
        isTappedIn = false
        
        let timeSpent = tapOutTime.timeIntervalSince(tapInTime) // Time in seconds
        let hours = Int(timeSpent) / 3600
        let minutes = (Int(timeSpent) % 3600) / 60
        let seconds = Int(timeSpent) % 60
        timeSpentToday = String(format: "%dh %dm %ds", hours, minutes, seconds)
        
        saveDailyTime(hours: timeSpent / 3600) // Save in hours
        saveState()
    }

    
    private func saveDailyTime(hours: Double) {
        let day = currentDayOfWeek()
        weeklyData[day] = hours
    }
    
    private func currentDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: Date())
    }
    
    private func saveState() {
        userDefaults.set(isTappedIn, forKey: "isTappedIn")
        userDefaults.set(tapInTime, forKey: "tapInTime")
        userDefaults.set(timeSpentToday, forKey: "timeSpentToday")
        userDefaults.set(weeklyData, forKey: "weeklyData")
    }
    
    private func loadState() {
        isTappedIn = userDefaults.bool(forKey: "isTappedIn")
        tapInTime = userDefaults.object(forKey: "tapInTime") as? Date
        timeSpentToday = userDefaults.string(forKey: "timeSpentToday") ?? "0h 0m"
        if let data = userDefaults.dictionary(forKey: "weeklyData") as? [String: Double] {
            weeklyData = data
        }
    }
}
