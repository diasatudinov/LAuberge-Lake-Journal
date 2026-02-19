//
//  Last6MonthsLakesBarChartView.swift
//  LAuberge Lake Journal
//
//


import SwiftUI
import Charts

struct Last6MonthsLakesBarChartView: View {
    @ObservedObject var viewModel: LJLakeViewModel

        private struct MonthStat: Identifiable, Equatable {
            let id = UUID()
            let monthStart: Date
            let monthLabel: String        // короткое: "FEB"
            let fullMonthLabel: String    // полное: "February 2026" (по локали)
            let count: Int
            let isMax: Bool
        }

        @State private var stats: [MonthStat] = []
        @State private var maxCount: Int = 0
        @State private var maxMonth: MonthStat? = nil

        private let zeroBarHeight: CGFloat = 8

        var body: some View {
            VStack(spacing: 10) {

                GeometryReader { geo in
                    let totalHeight = geo.size.height
                    let headerHeight: CGFloat = 26
                    let barAreaHeight = max(1, totalHeight - headerHeight)

                    HStack(alignment: .bottom, spacing: 25) {
                        ForEach(stats) { item in
                            VStack(spacing: 0) {

                                // бар
                                ZStack(alignment: .bottom) {
                                    let h = barHeight(count: item.count, barAreaHeight: barAreaHeight)

                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 12,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 12
                                    )
                                    .fill(Color.accentBlue)
                                    .frame(height: h)
                                    .overlay(alignment: .top) {
                                        if item.isMax {
                                            Text("MAX")
                                                .font(.system(size: 12, weight: .regular))
                                                .foregroundStyle(.white)
                                                .padding(.top)
                                        }
                                    }

                                    if item.count > 0 {
                                        Text("(\(item.count))")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundStyle(.white.opacity(0.5))
                                            .monospacedDigit()
                                            .padding(.bottom, min(8, max(2, h * 0.25)))
                                    }
                                }

                                // подпись месяца
                                VStack(spacing: 2) {
                                    Text(item.monthLabel)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                                .frame(height: headerHeight)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: totalHeight)
                }
                .frame(height: 197)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.white.opacity(0.05))
                
                // ✅ Инфа под графиком про максимальный месяц
                if let maxMonth, maxCount > 0 {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Top month")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Text(maxMonth.fullMonthLabel)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()

                        VStack(alignment: .trailing, spacing: 5) {
                            Text("quantity")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                            Text("\(maxMonth.count)")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .monospacedDigit()
                        }
                        
                    }
                } else {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Top month")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Text("-")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()

                        VStack(alignment: .trailing, spacing: 5) {
                            Text("quantity")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                            Text("-")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .monospacedDigit()
                        }
                        
                    }
                }
            }
            .task { await rebuild() }
            .onChange(of: viewModel.lakes.count) { _ in
                Task { await rebuild() }
            }
        }

        private func barHeight(count: Int, barAreaHeight: CGFloat) -> CGFloat {
            guard maxCount > 0 else { return zeroBarHeight }
            if count == 0 { return zeroBarHeight }
            let scaled = CGFloat(count) / CGFloat(maxCount) * barAreaHeight
            return max(zeroBarHeight, scaled)
        }

        @MainActor
        private func rebuild() async {
            let snapshot = viewModel.lakes

            let result = await Task.detached(priority: .utility) { () -> ([MonthStat], Int, MonthStat?) in
                let cal = Calendar.current
                let now = Date()
                let thisMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: now))!

                let monthStarts: [Date] = (0..<6).reversed().compactMap { offset in
                    cal.date(byAdding: .month, value: -offset, to: thisMonthStart)
                }

                var counts: [Date: Int] = [:]
                for m in monthStarts { counts[m] = 0 }

                for lake in snapshot {
                    let m = cal.date(from: cal.dateComponents([.year, .month], from: lake.date))!
                    if counts[m] != nil { counts[m, default: 0] += 1 }
                }

                let shortFmt = DateFormatter()
                shortFmt.locale = .current
                shortFmt.dateFormat = "MMM"

                let fullFmt = DateFormatter()
                fullFmt.locale = .current
                fullFmt.dateFormat = "LLLL"   // February 2026 (по локали)

                let raw = monthStarts.map { start in
                    (
                        start: start,
                        short: shortFmt.string(from: start).uppercased(),
                        full: fullFmt.string(from: start),
                        count: counts[start, default: 0]
                    )
                }

                let maxCount = raw.map(\.count).max() ?? 0

                let stats = raw.map { item in
                    MonthStat(
                        monthStart: item.start,
                        monthLabel: item.short,
                        fullMonthLabel: item.full,
                        count: item.count,
                        isMax: maxCount > 0 && item.count == maxCount
                    )
                }

                let maxMonth = stats.first(where: { $0.isMax })
                return (stats, maxCount, maxMonth)
            }.value

            stats = result.0
            maxCount = result.1
            maxMonth = result.2
        }
    }

#Preview {
    Last6MonthsLakesBarChartView(viewModel: LJLakeViewModel())
}
