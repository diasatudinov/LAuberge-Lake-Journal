//
//  LJLakeCellView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct LJLakeCellView: View {
    let lake: Lake
    var body: some View {
        
        if lake.gallery.isEmpty {
            Image(.placeholderLJ)
                .resizable()
                .scaledToFit()
                .opacity(0.5)
                .overlay(alignment: .topTrailing) {
                    HStack(spacing: 2) {
                        Image(lake.waterClarity.icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundStyle(lake.waterClarity.color)
                        
                        Text(lake.waterClarity.text)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(lake.waterClarity.color)
                    }
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(lake.waterClarity.color)
                    }
                    .padding(32)
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        Text(lake.name)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        HStack {
                            Image(systemName: "calendar")
                            
                            Text(formattedTime(lake.date))
                                
                        }
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(32)
                    
                }
        } else {
            DownsampledFileImageView(
                fileURL: lake.gallery.first.flatMap { imageURL(for: $0) },
                cacheID: "\(lake.id.uuidString)_v\(lake.gallery.first ?? "none")",
                contentMode: .fill
            )
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .overlay(alignment: .topTrailing) {
                    HStack(spacing: 2) {
                        Image(lake.waterClarity.icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundStyle(lake.waterClarity.color)
                        
                        Text(lake.waterClarity.text)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(lake.waterClarity.color)
                    }
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(lake.waterClarity.color)
                    }
                    .padding(32)
                }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        Text(lake.name)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        HStack {
                            Image(systemName: "calendar")
                            
                            Text(formattedTime(lake.date))
                                
                        }
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(32)
                    
                }
        }
        
        
    }
    
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: time)
    }
}

#Preview {
    LJLakeCellView(lake: Lake(name: "Lake", date: .now, waterClarity: .crystal, mood: .adventure, story: "asdas dsadad ad asdsadasd"))
}
