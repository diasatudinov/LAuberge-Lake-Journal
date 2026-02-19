//
//  LJGalleryView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct LJGalleryView: View {
    @ObservedObject var viewModel: LJLakeViewModel
    
    @State private var selectedFilter: WaterClarity? = nil   // nil = все фото
    
    // MARK: - Flatten photos
    private struct PhotoItem: Identifiable, Hashable {
        let id: String            // stable
        let lakeID: UUID
        let fileName: String
        let clarity: WaterClarity
        let name: String
        let date: Date
    }
    
    private var allPhotos: [PhotoItem] {
        viewModel.lakes.flatMap { lake in
            lake.gallery.map { fileName in
                PhotoItem(
                    id: "\(lake.id.uuidString)_v\(fileName ?? "none")",
                    lakeID: lake.id,
                    fileName: fileName,
                    clarity: lake.waterClarity,
                    name: lake.name,
                    date: lake.date
                )
            }
        }
    }
    
    private var filteredPhotos: [PhotoItem] {
        guard let selectedFilter else { return allPhotos }
        return allPhotos.filter { $0.clarity == selectedFilter }
    }
    
    private let cols: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            
            HStack(spacing: .zero) {
                
                Text("All Lake Memories")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }.padding(.top, 8)
            
            // MARK: - Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    filterChip(title: "All photo", isSelected: selectedFilter == nil, icon: "photoIconLJ") {
                        selectedFilter = nil
                    }
                    
                    ForEach(WaterClarity.allCases, id: \.self) { c in
                        filterChip(title: c.text, isSelected: selectedFilter == c, icon: c.icon) {
                            selectedFilter = c
                        }
                    }
                }
            }
            
            // MARK: - Grid
            if filteredPhotos.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text("No photos")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 30)
            } else {
                ScrollView {
                    VStack {
                        
                        PhotoCell(fileName: filteredPhotos[0].fileName, cacheID: filteredPhotos[0].id, name: filteredPhotos[0].name, date: filteredPhotos[0].date)
                            .scaledToFit()
                        
                        LazyVGrid(columns: cols, spacing: 8) {
                            ForEach(Array(filteredPhotos.enumerated()), id: \.element.id) { index, item in
                                
                                if index > 0 {
                                    PhotoLittleCell(fileName: item.fileName, cacheID: item.id, name: item.name, date: item.date)
                                }
                            }
                        }
                        
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .padding(.horizontal)
        .background(.black)
    }
    
    // MARK: - UI helpers
    
    @ViewBuilder
    private func filterChip(title: String, isSelected: Bool, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? .accentBlue : Color.cellBg)
            )
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Photo cell (uses your file loader view)

private struct PhotoLittleCell: View {
    let fileName: String
    let cacheID: String
    let name: String
    let date: Date
    var body: some View {
        DownsampledFileImageView(
            fileURL: imageURL(for: fileName),
            cacheID: cacheID,
            contentMode: .fill
        )
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                
                HStack {
                    Image(systemName: "calendar")
                    
                    Text(formattedTime(date))
                        .fixedSize()
                        
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
            }
            .padding(16)
            
        }
    }
    
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: time)
    }
}

private struct PhotoCell: View {
    let fileName: String
    let cacheID: String
    let name: String
    let date: Date
    var body: some View {
        DownsampledFileImageView(
            fileURL: imageURL(for: fileName),
            cacheID: cacheID,
            contentMode: .fill
        )
        .scaledToFit()
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                
                HStack {
                    Image(systemName: "calendar")
                    
                    Text(formattedTime(date))
                        .fixedSize()
                        
                }
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
            }
            .padding(32)
            
        }
    }
    
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: time)
    }
}

#Preview {
    LJGalleryView(viewModel: LJLakeViewModel())
}
