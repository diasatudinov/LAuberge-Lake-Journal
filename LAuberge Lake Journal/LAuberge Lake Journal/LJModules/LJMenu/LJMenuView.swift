//
//  LJMenuView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

import SwiftUI

struct BBMenuContainer: View {
    
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                LJMenuView()
            }
        }
    }
}


struct LJMenuView: View {
    @State var selectedTab = 0
    @StateObject var viewModel = LJLakeViewModel()
    private let tabs = ["My dives", "Calendar", "Stats"]
        
    var body: some View {
        ZStack {
            
            switch selectedTab {
            case 0:
                LJHomeView(viewModel: viewModel)
            case 1:
                LJStatsView(viewModel: viewModel)
            case 2:
                LJGalleryView(viewModel: viewModel)
            default:
                Text("default")
            }
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            VStack {
                                Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                
                                Text(text(for: index))
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(selectedTab == index ? .accentBlue : .primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(selectedTab == index ? .black.opacity(0.1) : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .padding(6)
                            
                            
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(0.55)) // прозрачнее
                        .overlay(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.18),
                                    .white.opacity(0.03),
                                    .white.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .blendMode(.overlay)
                        )
                        .overlay(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.22),
                                    .clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 140
                            )
                            .blendMode(.screen)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.22),
                                            .white.opacity(0.04),
                                            .white.opacity(0.14)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.8
                                )
                        )
                        .shadow(color: .black.opacity(0.10), radius: 14, x: 0, y: 8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.bottom, 21)
                .padding(.horizontal, 50)
                
            }
            .ignoresSafeArea()
            
            
        }
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1Icon"
        case 1: return "tab2Icon"
        case 2: return "tab3Icon"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelected"
        case 1: return "tab2IconSelected"
        case 2: return "tab3IconSelected"
        default: return ""
        }
    }
    
    private func text(for index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Stats"
        case 2: return "Gallery"
        default: return ""
        }
    }
}
#Preview {
    LJMenuView()
}

struct LiquidGlassBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(.ultraThinMaterial)                       // стекло (iOS 16)
            .overlay(                                       // "жидкая" подсветка
                LinearGradient(
                    colors: [
                        .white.opacity(0.45),
                        .white.opacity(0.08),
                        .white.opacity(0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blendMode(.overlay)
            )
            .overlay(                                       // блик (как у стекла)
                RadialGradient(
                    colors: [
                        .white.opacity(0.55),
                        .clear
                    ],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 180
                )
                .blendMode(.screen)
            )
            .overlay(                                       // тонкая “стеклянная” обводка
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.55),
                                .white.opacity(0.10),
                                .white.opacity(0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }
}
