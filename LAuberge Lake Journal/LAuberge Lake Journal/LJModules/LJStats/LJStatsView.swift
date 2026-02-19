//
//  LJStatsView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct LJStatsView: View {
    @ObservedObject var viewModel: LJLakeViewModel
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: .zero) {
                
                Text("Journal Statistics")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }.padding(.vertical, 8)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(.journeysIconLJ)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 10)
                                
                                Text("Journeys")
                                    .font(.system(size: 14, weight: .regular))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            
                            Text("12 Lakes")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.cellBg)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(.capturesIconLJ)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                
                                Text("captures")
                                    .font(.system(size: 14, weight: .regular))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            
                            Text("247 Photos")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.cellBg)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(.clarityIconLJ)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            
                            Text("Water Clarity")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        WaterClarityDonutStatsView(viewModel: viewModel)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.cellBg)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(.visitsIconLJ)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            
                            Text("Monthly Visits")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        Last6MonthsLakesBarChartView(viewModel: viewModel)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.cellBg)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                }.padding(.bottom, 150)
            }
        }
        .padding(.horizontal)
        .background(.mainBlack)
    }
}

#Preview {
    LJStatsView(viewModel: LJLakeViewModel())
}
