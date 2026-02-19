//
//  LJLakeDetailsView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct LJLakeDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: LJLakeViewModel
    let lake: Lake
    
    @State private var page = 0
    
    private let levels = Array(WaterClarity.allCases.reversed())
    private var filledCount: Int {
        // muddy -> 1, murky -> 2, clear -> 3, crystal -> 4
        (levels.firstIndex(of: lake.waterClarity) ?? 0) + 1
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        LakePhotoCarousel(lake: lake, page: $page)
                            .frame(height: UIScreen.main.bounds.height / 2.5)
                            .overlay(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    Text(lake.name)
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundStyle(.white)
                                    
                                    HStack(spacing: 4) {
                                        if !lake.gallery.isEmpty {
                                            ForEach(Range(0...lake.gallery.count - 1)) { page in
                                                Rectangle()
                                                    .frame(height: 5)
                                                    .foregroundStyle(self.page == page ? .white : .white.opacity(0.4))
                                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                                
                                            }
                                        } else {
                                            Rectangle()
                                                .frame(height: 5)
                                                .foregroundStyle(self.page == page ? .white : .white.opacity(0.4))
                                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                                .opacity(0)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack(spacing: 45) {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Visited on")
                                        .font(.system(size: 17, weight: .semibold))
                                        .textCase(.uppercase)
                                        .foregroundStyle(.accentBlue)
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                        
                                        Text(formattedTime(lake.date))
                                            .fixedSize()
                                    }
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("current mood")
                                        .font(.system(size: 17, weight: .semibold))
                                        .textCase(.uppercase)
                                        .foregroundStyle(.accentBlue)
                                    
                                    HStack {
                                        Image(lake.mood.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 20)
                                        
                                        Text(lake.mood.text)
                                            
                                            
                                    }
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundStyle(.white)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.white.opacity(0.05))
                                .padding(.vertical, 8)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("water clarity")
                                    .font(.system(size: 17, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.accentBlue)
                                
                                HStack {
                                    ForEach(levels.indices, id: \.self) { i in
                                        VStack {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 8)
                                                .foregroundStyle(i < filledCount ? lake.waterClarity.color : Color.white.opacity(0.18))
                                            Text(levels[i].text)
                                                .foregroundStyle(i == filledCount - 1 ? lake.waterClarity.color : Color.white.opacity(0.18))
                                            
                                        }
                                    }
                                }
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.white.opacity(0.05))
                                .padding(.vertical, 8)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Journal entry")
                                    .font(.system(size: 17, weight: .semibold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(.accentBlue)
                                
                                Text(lake.story)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            }
                            
                        }.padding(.horizontal)
                    }
                    .padding(.bottom, 50)
                }
                .ignoresSafeArea()
            }
            .background(.mainBlack)
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(.secondaryBlack)
                            .clipShape(Circle())
                        
                        
                    }.buttonStyle(.plain)
                    
                    NavigationLink {
                        LJEditLakeView(viewModel: viewModel, lake: lake)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(.secondaryBlack)
                            .clipShape(Circle())
                        
                        
                    }.buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Button {
                        viewModel.delete(lake: lake)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(.secondaryBlack)
                            .clipShape(Circle())
                        
                        
                    }.buttonStyle(.plain)
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                
            
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
    NavigationStack {
        LJHomeView(viewModel: LJLakeViewModel())
    }
}

//#Preview {
//    LJLakeDetailsView(viewModel: LJLakeViewModel(), lake: Lake(name: "Lake", date: .now, waterClarity: .crystal, mood: .adventure, story: "asdjlajsdkj lakdjklaj kdjsakld jkasldjkasldj kassakldjka jskadjkasldj kalsdjkasjska ldjkasldjkasjdk lajskd jaks djskaldjkl jksaldjaksldj kasdjksdjk jksjdksjkdalsdjkas jdkasjd klasjd kjd klasjd klasjd kajs dklajsd klasjd kasjd klajdk asjd klasjd klasj dklasd jkas djklasdjklsadjk laj das dsadad ad asdsadasd"))
//}

struct LakePhotoCarousel: View {
    let lake: Lake
    @Binding var page: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            if lake.gallery.isEmpty {
                ZStack {
                    Rectangle()
                        .fill(.gray.opacity(0.15))
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 42, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            } else {
                TabView(selection: $page) {
                    ForEach(Array(lake.gallery.enumerated()), id: \.offset) { index, fileName in
                        DownsampledFileImageView(
                            fileURL: imageURL(for: fileName),
                            cacheID: "\(lake.id.uuidString)_\(fileName)",
                            contentMode: .fill
                        )
                        .tag(index)
                        .scaledToFill()
                        .ignoresSafeArea(edges: .top)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

            }
        }
    }
}
