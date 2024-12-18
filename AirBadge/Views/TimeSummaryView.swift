import SwiftUI
import Charts

struct TimeSummaryView: View {
    let timeSpentToday: String
    let weeklyData: [String: Double]
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    @State private var animateChart = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Time Tracker")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 20)
            
            // Chart Styling
            Chart {
                ForEach(daysOfWeek, id: \.self) { day in
                    BarMark(
                        x: .value("Day", day),
                        y: .value("Hours", animateChart ? weeklyData[day] ?? 0 : 0)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.green]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )  // Apply gradient color
                    .cornerRadius(10)  // Rounded corners for bars
                    .shadow(radius: 5)  // Add shadow to bars for depth
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine().foregroundStyle(Color.gray.opacity(0.3))
                    AxisTick().foregroundStyle(Color.black)
                    AxisValueLabel().foregroundStyle(Color.black)
                        .font(.system(size: 14, weight: .regular))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine().foregroundStyle(Color.gray.opacity(0.3))
                    AxisTick().foregroundStyle(Color.black)
                    AxisValueLabel().foregroundStyle(Color.black)
                        .font(.system(size: 14, weight: .regular))
                }
            }
            .frame(height: 250)  // Adjust chart height
            .padding(.horizontal, 20)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    animateChart = true
                }
            }
            
            Text("Today: \(timeSpentToday)")
                .font(.headline)
                .padding(.leading, 10)
        }
    }
}
