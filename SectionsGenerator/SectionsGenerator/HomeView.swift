//
//  HomeView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 31/07/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var sectionsShowed: [SectionModel] = []
    
    @State private var allSections: [SectionModel] = [
        .init(section: .init(sectionType: "SECTION")),
        .init(section: ButtonModel(text: "Text", type: .secondary))
    ]
    
    @State private var currentlyDragging: SectionModel?
    @State private var isFromPreview: Bool?

    var body: some View {
        HStack {
            Spacer()
            sectionsPreview
            Spacer()
            sectionsList
            Spacer()
            sectionsConfig
            Spacer()
        }
        .padding()
    }
    
    var sectionsPreview: some View {
        VStack(spacing: 2) {
            if sectionsShowed.isEmpty {
                emptyDropArea(currentItemArray: $sectionsShowed, otherItemArray: $allSections)
            } else {
                ForEach(sectionsShowed) { section in
                    SectionView(model: section)
                    .padding(.horizontal, 24)
                    .onDrag {
                        self.currentlyDragging = section
                        self.isFromPreview = true
                        return NSItemProvider(object: section.section.sectionType as NSString)
                    }
                    .onDrop(of: ["public.text"], delegate: SectionDropDelegate(section: section, currentSections: $sectionsShowed, anotherSections: $allSections, draggedSection: $currentlyDragging, isLastItem: sectionsShowed.last == section))
            }
            Rectangle()
                .background(.white)
                .frame(maxHeight: .infinity)
                .padding(.horizontal, 24)
                .onDrop(of: ["public.text"], delegate: SectionDropDelegate(section: nil, currentSections: $sectionsShowed, anotherSections: $allSections, draggedSection: $currentlyDragging, isLastItem: true))
        }
        }
        .padding(.vertical, 40)
        .frame(maxHeight: .infinity)
        .frame(width: 400)
        .border(.black, width: 20)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    var sectionsList: some View {
        VStack {
            if allSections.isEmpty {
                emptyDropArea(currentItemArray: $allSections, otherItemArray: $sectionsShowed)
            } else {
                ForEach(allSections) { section in
                    SectionView(model: section)
                        .padding(.horizontal, 24)
                        .onTapGesture {
                            print(section.section.listProperties())
                        }
                        .onDrag {
                            self.currentlyDragging = section
                            self.isFromPreview = false
                            return NSItemProvider(object: section.section.sectionType as NSString)
                        }
                }
            }
        }
        .padding(.vertical, 40)
        .frame(maxHeight: .infinity)
        .frame(width: 400)
        .border(.black, width: 20)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
        .onDrop(of: ["public.text"], delegate: RemoveDropDelegate(sections: $sectionsShowed, draggedSection: $currentlyDragging, isFromPreview: isFromPreview ?? false))
    }
    
    var sectionsConfig: some View {
        VStack {
            Text("Configurações")
                .bold()
                .font(.title)
                .foregroundStyle(.gray)
            configList
            Spacer()
        }
        .padding(.vertical, 40)
        .frame(maxHeight: .infinity)
        .frame(width: 400)
        .border(.gray, width: 20)
        .background(.white)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    @State private var name: String = ""
    
    var configList: some View {
        VStack {
            Text("STANDALONE_BUTTON")
                .font(.title2)
                .foregroundStyle(.black)
            TextField("Enter your name", text: $name)
                .background(.red)
                .padding()
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(12)
        .background(Color("lightGray"))
        .clipShape(.rect(cornerRadius: 8))
    }
    
    func emptyDropArea(currentItemArray: Binding<[SectionModel]>, otherItemArray: Binding<[SectionModel]>) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(Text("Drop items here").foregroundColor(.gray))
            .onDrop(of: ["public.text"], delegate: EmptySectionDropDelegate(currentItemArray: currentItemArray, otherItemArray: otherItemArray, draggedItem: $currentlyDragging))
    }
}
