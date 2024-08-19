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
        .init(section: ButtonModel(text: "Text", type: .primary)),
        .init(section: CardModel(icon: "heart", text: "Texto", type: .blue))
    ]
    
    @State private var currentlyDragging: SectionModel?
    @State private var isFromPreview: Bool?
    @State private var showingConfig: Bool = false
    @State private var types: [VarType] = []
    @State private var configBindings: [String: String] = [:]
    @State private var actualSectionConfig: SectionModel?
    
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
                            tapSection(section)
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
            if showingConfig {
                Text("Configurações")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.gray)
                configList
                Spacer()
            }
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
            Text(actualSectionConfig?.section.sectionType ?? "")
                .font(.title2)
                .foregroundStyle(.black)
            ForEach(types) { type in
                MyTextField(placeholder: type.name,
                            value: Binding(
                                get: { configBindings[type.name, default: ""] },
                                set: { configBindings[type.name] = $0 }
                            ))
            }
            Button {
                saveConfig()
            } label: {
                Text("Salvar")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.title)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 8))
            }

        }
        .padding(.horizontal, 16)
    }
    
    func emptyDropArea(currentItemArray: Binding<[SectionModel]>, otherItemArray: Binding<[SectionModel]>) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(Text("Drop items here").foregroundColor(.gray))
            .onDrop(of: ["public.text"], delegate: EmptySectionDropDelegate(currentItemArray: currentItemArray, otherItemArray: otherItemArray, draggedItem: $currentlyDragging))
    }
    
    //MARK: - PRIVATE METHODS

    private func tapSection(_ section: SectionModel) {
        self.configBindings = [:]
        self.types = section.section.listProperties()
        if actualSectionConfig == section && showingConfig{
            showingConfig = false
        } else {
            showingConfig = true
        }
        self.actualSectionConfig = section
    }
    
    private func saveConfig() {
        guard let actualSection = actualSectionConfig else { return }
        guard let newModel = actualSection.section.getModelByProperties(properties: configBindings)
        else { return }
        let newSection = SectionModel(section: newModel)
        replaceSection(id: actualSection.id, in: &allSections, with: newSection)
        showingConfig = false
    }
    
    private func replaceSection(id: UUID, in sections: inout [SectionModel], with newSection: SectionModel) {
        if let index = sections.firstIndex(where: { $0.id == id }) {
            sections[index] = newSection
        }
    }
}
