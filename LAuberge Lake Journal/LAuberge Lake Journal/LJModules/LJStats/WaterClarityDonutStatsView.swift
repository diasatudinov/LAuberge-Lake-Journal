//
//  WaterClarityDonutStatsView.swift
//  LAuberge Lake Journal
//
//


import SwiftUI

// MARK: - Main View

struct WaterClarityDonutStatsView: View {
    @ObservedObject var viewModel: LJLakeViewModel

    private var total: Int { viewModel.lakes.count }

    /// Порядок можно менять. Я ставлю от худшего к лучшему как ты делал reversed()
    private var orderedCases: [WaterClarity] {
        Array(WaterClarity.allCases.reversed()) // muddy, murky, clear, crystal
    }

    private var countsByClarity: [WaterClarity: Int] {
        var dict: [WaterClarity: Int] = [:]
        for c in orderedCases { dict[c] = 0 }
        for lake in viewModel.lakes {
            dict[lake.waterClarity, default: 0] += 1
        }
        return dict
    }

    private var hasData: Bool { total > 0 }

    private var segments: [DonutSegment] {
        guard hasData else { return [] }

        var start: Double = -.pi / 2 // старт сверху
        var result: [DonutSegment] = []

        for clarity in orderedCases {
            let count = countsByClarity[clarity, default: 0]
            guard count > 0 else { continue }

            let fraction = Double(count) / Double(total)
            let end = start + (2 * .pi * fraction)

            result.append(
                DonutSegment(
                    startAngle: start,
                    endAngle: end,
                    color: clarity.color,
                    label: clarity.text,
                    fraction: fraction
                )
            )
            start = end
        }
        return result
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                if hasData, !segments.isEmpty {
                    DonutChart(segments: segments, lineWidth: 28)
                        .frame(width: 220, height: 220)

                    VStack(spacing: 6) {
                        Text("Global")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                } else {
                    DonutChart(
                        segments: [
                            DonutSegment(
                                startAngle: -.pi/2,
                                endAngle: 1.5 * .pi,
                                color: .gray.opacity(0.25),
                                label: "No data",
                                fraction: 1
                            )
                        ],
                        lineWidth: 28
                    )
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                   // .frame(width: 300, height: 200)

                    Text("no data")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            // MARK: - Legend / breakdown
            VStack(alignment: .leading, spacing: 10) {
                ForEach(orderedCases, id: \.self) { clarity in
                    let count = countsByClarity[clarity, default: 0]
                    let percent = hasData ? (Double(count) / Double(total) * 100.0) : 0.0

                    HStack(spacing: 5) {
                        Circle()
                            .fill(clarity.color)
                            .frame(width: 12, height: 12)

                        Text(clarity.text)
                            .foregroundStyle(.white.opacity(0.5))

                        Text(String(format: "(%.0f%%)", percent))
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.5))
                            .monospacedDigit()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
        .padding()
    }
}

// MARK: - Donut chart primitives

struct DonutSegment: Identifiable {
    let id = UUID()
    let startAngle: Double
    let endAngle: Double
    let color: Color
    let label: String
    let fraction: Double
}

struct DonutChart: View {
    let segments: [DonutSegment]
    var lineWidth: CGFloat = 24

    var body: some View {
        ZStack {
            ForEach(segments) { seg in
                DonutArc(startAngle: seg.startAngle, endAngle: seg.endAngle)
                    .stroke(seg.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    .rotationEffect(.degrees(0))
                    .padding()
            }
        }
        .drawingGroup()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Water clarity distribution")
    }
}

struct DonutArc: Shape {
    var startAngle: Double
    var endAngle: Double

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        p.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        return p
    }
}

#Preview {
    LJStatsView(viewModel: LJLakeViewModel())
}
