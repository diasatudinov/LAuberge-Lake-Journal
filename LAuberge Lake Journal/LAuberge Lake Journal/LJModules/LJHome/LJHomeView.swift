//
//  LJHomeView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct LJHomeView: View {
    @ObservedObject var viewModel: LJLakeViewModel
    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                
                Text("Lake journal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink {
                    LJNewLake(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("+")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8).padding(.horizontal, 11)
                }
            }.padding(.vertical, 8)
            
            if viewModel.lakes.isEmpty {
                VStack {
                    Text("No entries yet")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("Your lake is waiting")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.bottom, 150)
                
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(viewModel.lakes, id: \.id) { lake in
                            NavigationLink {
                                LJLakeDetailsView(viewModel: viewModel, lake: lake)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                LJLakeCellView(lake: lake)
                            }
                        }
                    }
                    .padding(.bottom, 150)
                }
            }
            
        }
        .padding(.horizontal)
        .background(.mainBlack)
    }
    
}

#Preview {
    NavigationStack {
        LJHomeView(viewModel: LJLakeViewModel())
    }
}
