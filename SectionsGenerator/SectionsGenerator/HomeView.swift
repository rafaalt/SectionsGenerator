//
//  HomeView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 31/07/24.
//

import SwiftUI

struct HomeView: View {
    @State var string = "iphone"
    @State private var sectionsShowed: [SectionModel] = [
    ]
    
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
    
    //MARK: - BODY
    
    var body: some View {
        HStack {
            VStack {
                trashSpacer(currentlyDragging, isFromPreview)
                    .frame(width: 400)
            }
            sectionsPreview
            sectionsList
            sectionsConfig
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundColor"))
        .onDrop(of: ["public.text"], delegate: FullScreenDelegate(draggedSection: $currentlyDragging))
    }
    
    //MARK: - VIEWS
    
    var sectionsPreview: some View {
        VStack {
            HStack {
                Text("Preview ")
                    .bold()
                    .font(.largeTitle)
                    .padding(.trailing, 8)
                Button(action: {
                    getJson()
                }) {
                    Image(systemName: "doc.fill.badge.plus")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                }
            }
            ZStack {
                if sectionsShowed.isEmpty {
                    emptyDropArea(currentSectionArray: $sectionsShowed, otherSectionArray: $allSections)
                } else {
                    VStack(spacing: 2) {
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
                        previewEmptySlot
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(.rect(cornerRadius: 16))
                    .padding(.top, 90)
                    .padding(.bottom, 30)
                    .padding(.leading, 35)
                    .padding(.trailing, 45)
                }
                Image(string)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .allowsHitTesting(false)
            }
            .frame(width: 500, height: 955)
        }
    }
    
    var previewEmptySlot: some View {
        Rectangle()
            .foregroundStyle(Color("iphoneBackground"))
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 24)
            .onDrop(of: ["public.text"], delegate: SectionDropDelegate(section: nil, currentSections: $sectionsShowed, anotherSections: $allSections, draggedSection: $currentlyDragging, isLastItem: true))
    }
    
    var sectionsList: some View {
        VStack {
            Text("Lista de Sections")
                .bold()
                .font(.largeTitle)
            ZStack {
                VStack(spacing: 0) {
                    ForEach(allSections) { section in
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(section.section.sectionType):")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .onTapGesture {
                                tapSection(section)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 4)
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
                            Rectangle()
                                .fill(.gray.opacity(0.5))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                        }
                        .background(.white)
                        .padding(.horizontal, 4)
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.top, 90)
                .padding(.bottom, 30)
                .padding(.leading, 35)
                .padding(.trailing, 45)
                Image(string)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .allowsHitTesting(false)
            }
            .frame(width: 500, height: 955)
        }
    }
    
    var getJsonButton: some View {
        Button(action: {
            getJson()
        }) {
            VStack {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                
                Text("Download")
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.top, 8)
            }
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(width: 140, height: 140)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    func trashSpacer(_ drag: SectionModel?, _ isFromPreview: Bool?) -> some View {
        if showTrash(drag, isFromPreview) {
            VStack {
                Image(systemName: "trash")
                    .font(.system(size: 100))
                    .foregroundStyle(.black.opacity(0.7))
                HStack {
                    Text("   Arraste aqui pra remover do Preview")
                        .font(.title)
                        .foregroundStyle(.black.opacity(0.7))
                        .padding(.top, 6)
                        .padding(.horizontal, 10)
                }
            }
            .frame(width: 300, height: 300)
            .background(.red.opacity(0.25))
            .clipShape(.rect(cornerRadius: 12))
            .onDrop(of: ["public.text"], delegate: RemoveDropDelegate(sections: $sectionsShowed, draggedSection: $currentlyDragging, isFromPreview: isFromPreview ?? false))
        } else {
            Rectangle()
                .foregroundStyle(Color("backgroundColor"))
                .frame(width: 300, height: 300)
        }
    }
    
    var sectionsConfig: some View {
        VStack{
            Spacer()
            if showingConfig {
                configList
                    .padding(.horizontal, 24)
                    .clipShape(.rect(cornerRadius: 16))
            }
            Spacer()
            Spacer()
        }
        .frame(width: 400)
        .padding(24)
    }
    
    var configList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
            Spacer()
            Text("Configurações")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.gray)
                .padding(.bottom, 10)
            Spacer()
            }
            
            HStack {
                Spacer()
                Text(actualSectionConfig?.section.sectionType ?? "")
                    .font(.title2)
                    .foregroundStyle(Color("textColor"))
                    .padding(.bottom, 15)
                Spacer()
            }

            ForEach(types) { type in
                TextField(getPlaceholderString(type: type),
                          text: Binding(
                              get: { configBindings[type.name, default: ""] },
                              set: { configBindings[type.name] = $0 }
                          ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(height: 50)
            }
            Button(action: {
                saveConfig()
            }) {
                Text("Salvar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
        }
        .padding(12)
        .background(Color("lightGray"))
        .clipShape(.rect(cornerRadius: 12))
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
    }
    
    func emptyDropArea(currentSectionArray: Binding<[SectionModel]>, otherSectionArray: Binding<[SectionModel]>) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.vertical, 30)
            .padding(.leading, 35)
            .padding(.trailing, 45)
            .overlay(Text("Drop items here").foregroundColor(.gray))
            .onDrop(of: ["public.text"], delegate: EmptySectionDropDelegate(currentSectionArray: currentSectionArray, otherSectionArray: otherSectionArray, draggedSection: $currentlyDragging))
    }
    
    //MARK: - PRIVATE METHODS

    private func tapSection(_ section: SectionModel) {
        print(section.section.toString())
        self.configBindings = [:]
        self.types = section.section.listProperties()
        if actualSectionConfig == section && showingConfig {
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
    
    private func getPlaceholderString(type: VarType) -> String {
        if type.isOptional {
            return type.name
        } else {
            return "\(type.name) (obrigatório)"
        }
    }
    
    private func getJson() {
        var string = "{\n\"sections\": [\n"
        for (index, section) in sectionsShowed.enumerated() {
            if index == 0 {
                string += section.section.toString()
            } else {
                string += ",\n"
                string += section.section.toString()
            }
        }
        string += "\n]\n}"
        copyToClipboard(text: string)
        print(string)
    }
    
    private func showTrash(_ drag: SectionModel?, _ isFromPreview: Bool?) -> Bool {
        guard let drag = drag,
              let isFromPreview = isFromPreview else { return false }
        return isFromPreview
    }
}
