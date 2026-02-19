import SwiftUI
import Charts

struct Last6MonthsLakesBarChartView: View {
    @ObservedObject var viewModel: LakesViewModel

    private struct MonthCount: Identifiable {
        let id = UUID()
        let monthStart: Date
        let monthLabel: String
        let count: Int
    }

    private var data: [MonthCount] {
        let cal = Calendar.current
        let now = Date()
        let thisMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: now))!

        // последние 6 месяцев включая текущий (от старого к новому)
        let starts: [Date] = (0..<6).reversed().compactMap { offset in
            cal.date(byAdding: .month, value: -offset, to: thisMonthStart)
        }

        // подготовим словарь monthStart -> count
        var dict: [Date: Int] = [:]
        for s in starts { dict[s] = 0 }

        for lake in viewModel.lakes {
            let m = cal.date(from: cal.dateComponents([.year, .month], from: lake.date))!
            if dict[m] != nil {
                dict[m, default: 0] += 1
            }
        }

        let fmt = DateFormatter()
        fmt.locale = .current
        fmt.dateFormat = "MMM" // "Feb", "Mar" и т.д. (по локали)

        return starts.map { s in
            MonthCount(
                monthStart: s,
                monthLabel: fmt.string(from: s).uppercased(),
                count: dict[s, default: 0]
            )
        }
    }

    private var maxCount: Int {
        data.map(\.count).max() ?? 0
    }

    var body: some View {
        Chart {
            ForEach(data) { item in
                BarMark(
                    x: .value("Month", item.monthStart),
                    y: .value("Count", item.count)
                )
                .cornerRadius(8)

                // число ВНУТРИ столбика
                .annotation(position: .overlay, alignment: .center) {
                    if item.count > 0 {
                        Text("\(item.count)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.25))
                            .clipShape(Capsule())
                    }
                }

                // название месяца НАД столбиком + MAX у максимального
                .annotation(position: .top, alignment: .center) {
                    VStack(spacing: 2) {
                        Text(item.monthLabel)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)

                        if maxCount > 0, item.count == maxCount {
                            Text("MAX")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 2)
                }
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.clear)
        }
        .frame(height: 220)
        .padding()
    }
}