//
//  LJEditLakeView.swift
//  LAuberge Lake Journal
//
//

import SwiftUI
import PhotosUI

struct LJEditLakeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: LJLakeViewModel
    let lake: Lake
    
    @State private var name = ""
    @State private var date: Date = Date.now
    @State private var waterClarity: WaterClarity = .crystal
    @State private var mood: Mood = .calmness
    @State private var story = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []
    @State private var isSaving = false
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    var body: some View {
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
                
                Text("Edit Entry")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(.secondaryBlack)
                    .clipShape(Circle())
                    .opacity(0)
            }
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    textFiled(title: "Lake name") {
                        TextField("Where are you today?", text: $name)
                            .padding(.vertical, 11)
                            .padding(.horizontal, 16)
                            .background(.secondaryBlack)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(alignment: .leading) {
                                if name.isEmpty {
                                    Text("New Entry")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(.white.opacity(0.6))
                                        .padding(.leading)
                                        .allowsHitTesting(false)
                                }
                            }
                        
                    }
                    
                    textFiled(title: "Visit date") {
                        
                        HStack(alignment: .bottom) {
                            DatePicker(
                                "\(formattedTime(date))",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .font(.system(size: 17, weight: .regular))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(.secondaryBlack)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            Spacer()
                            
                        }
                    }
                    
                    textFiled(title: "Water clarity") {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                ForEach(WaterClarity.allCases, id: \.self) { clarity in
                                    
                                    VStack {
                                        Image(clarity.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 24)
                                        Text(clarity.text)
                                            .font(.system(size: 17, weight: .regular))
                                            .foregroundStyle(.white)
                                    }
                                    .padding(20)
                                    .frame(minWidth: 90)
                                    .background(waterClarity == clarity ? .accentBlue : .secondaryBlack)
                                    .clipShape(RoundedRectangle(cornerRadius: 17))
                                    .onTapGesture {
                                        waterClarity = clarity
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    textFiled(title: "Current mood") {
                        
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                VStack {
                                    Image(mood.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 28)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(self.mood == mood ? .accentBlue.opacity(0.5) : .secondaryBlack)
                                .clipShape(RoundedRectangle(cornerRadius: 17))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 17)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.accentBlue)
                                })
                                .onTapGesture {
                                    self.mood = mood
                                }
                            }
                        }
                        
                    }
                    
                    textFiled(title: "Your story") {
                        
                        TextEditor(text: $story)
                            .font(.system(size: 17, weight: .regular))
                            .frame(height: 117)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.secondaryBlack)
                            )
                            .scrollContentBackground(.hidden)
                            .overlay(alignment: .topLeading) {
                                if story.isEmpty {
                                    Text("Describe your impressions")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundStyle(.white.opacity(0.6))
                                        .allowsHitTesting(false)
                                        .padding(.top, 10)
                                        .padding(.leading, 4)
                                }
                            }
                        
                    }
                    
                    gallery(title: "Gallery", secondTitle: "\(images.count)/10 photos") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 10,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    
                                    Image("camera.plusLJ")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 36)
                                        .padding(36)
                                        .background(.secondaryBlack)
                                        .clipShape(RoundedRectangle(cornerRadius: 17))
                                        
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(Array(images.enumerated()), id: \.offset) { index, uiImage in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 108, height: 108)
                                                .clipped()
                                                .cornerRadius(12)
                                            
                                            Button {
                                                remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .symbolRenderingMode(.palette)
                                                    .foregroundStyle(.white, .red)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                                .onChange(of: selectedItems) { newItems in
                                    Task { await loadImages(from: newItems) }
                                }
                            }
                        }
                    }
                        
                    Button {
                        
                        var lake = Lake(name: name, date: date, waterClarity: waterClarity, mood: mood, story: story, gallery: [])
                        var newFileNames: [String] = []
                        
                        if !images.isEmpty {
                            do {
                                isSaving = true
                                
                                newFileNames.reserveCapacity(images.count)
                                
                                for img in images {
                                    do {
                                        let fileName = try ImageStore.shared.save(image: img, id: UUID())
                                        newFileNames.append(fileName)
                                    } catch {
                                        print("Save error:", error)
                                    }
                                }
                                
                                images.removeAll()
                                isSaving = false
                            } catch {
                                print("Save image error:", error)
                            }
                        }
                        
                        viewModel.edit(lake: self.lake, name: name, date: date, waterClarity: waterClarity, mood: mood, story: story, gallery: newFileNames)
                        
                        dismiss()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Edit")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(.accentBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                        }
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
        .background(.mainBlack)
        .onAppear {
            name = lake.name
            date = lake.date
            waterClarity = lake.waterClarity
            mood = lake.mood
            story = lake.story
            images = lake.gallery.compactMap { ImageStore.shared.load(named: $0) }
        }
    }
    
    
    private func remove(at index: Int) {
        guard images.indices.contains(index), selectedItems.indices.contains(index) else { return }
        images.remove(at: index)
        selectedItems.remove(at: index)
    }
    
    @MainActor
    private func loadImages(from items: [PhotosPickerItem]) async {
        images.removeAll(keepingCapacity: true)
        
        // На всякий случай ограничим до maxPhotos
        let limitedItems = Array(items.prefix(10))
        
        for item in limitedItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }
        
        // Синхронизируем selection с тем, что реально оставили
        selectedItems = limitedItems
    }
    
    @ViewBuilder func textFiled<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8)  {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
            
            content()
        }
    }
    
    @ViewBuilder func gallery<Content: View>(
        title: String,
        secondTitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8)  {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(secondTitle)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            content()
        }
    }
    
    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: time)
    }
}


//#Preview {
//    LJEditLakeView(viewModel: LJLakeViewModel(), lake: Lake(name: "Lake", date: .now, waterClarity: .crystal, mood: .adventure, story: "asdjlajsdkj lakdjklaj kdjsakld jkasldjkasldj kassakldjka jskadjkasldj kalsdjkasjska ldjkasldjkasjdk lajskd jaks djskaldjkl jksaldjaksldj kasdjksdjk jksjdksjkdalsdjkas jdkasjd klasjd kjd klasjd klasjd kajs dklajsd klasjd kasjd klajdk asjd klasjd klasj dklasd jkas djklasdjklsadjk laj das dsadad ad asdsadasd"))
//}

#Preview {
    NavigationStack {
        LJHomeView(viewModel: LJLakeViewModel())
    }
}
