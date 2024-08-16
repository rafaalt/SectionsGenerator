//
//  TestView.swift
//  SectionsGenerator
//
//  Created by Rafael Torga on 16/08/24.
//

import SwiftUI

struct Item: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

struct TestView: View {
    @State private var leftItems: [Item] = [
        Item(name: "Item 1"),
        Item(name: "Item 2"),
        Item(name: "Item 3")
    ]
    
    @State private var rightItems: [Item] = [
        Item(name: "Item A"),
        Item(name: "Item B"),
        Item(name: "Item C")
    ]
    
    @State private var draggedItem: Item?
    
    var body: some View {
        HStack {
            VStack {
                Text("Left Stack")
                if leftItems.isEmpty {
                    emptyDropArea(currentItemArray: $leftItems, otherItemArray: $rightItems)
                } else {
                    ForEach(leftItems) { item in
                        Text(item.name)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .onDrag {
                                self.draggedItem = item
                                return NSItemProvider(object: item.name as NSString)
                            }
                            .onDrop(of: ["public.text"], delegate: ItemDropDelegate(item: item, currentItemArray: $leftItems, otherItemArray: $rightItems, draggedItem: $draggedItem, isLastItem: leftItems.last == item))
                    }
                }
            }
            .frame(width: 400)
            VStack {
                Text("Right Stack")
                if rightItems.isEmpty {
                    emptyDropArea(currentItemArray: $rightItems, otherItemArray: $leftItems)
                } else {
                    ForEach(rightItems) { item in
                        Text(item.name)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                            .onDrag {
                                self.draggedItem = item
                                return NSItemProvider(object: item.name as NSString)
                            }
                            .onDrop(of: ["public.text"], delegate: ItemDropDelegate(item: item, currentItemArray: $rightItems, otherItemArray: $leftItems, draggedItem: $draggedItem, isLastItem: rightItems.last == item))
                    }
                }
            }
            .frame(width: 400)
        }
        .padding()
    }
    
    // Função para criar uma área de drop para listas vazias
    func emptyDropArea(currentItemArray: Binding<[Item]>, otherItemArray: Binding<[Item]>) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 100)
            .overlay(Text("Drop items here").foregroundColor(.gray))
            .onDrop(of: ["public.text"], delegate: EmptyDropDelegate(currentItemArray: currentItemArray, otherItemArray: otherItemArray, draggedItem: $draggedItem))
    }
}

struct ItemDropDelegate: DropDelegate {
    let item: Item
    @Binding var currentItemArray: [Item]
    @Binding var otherItemArray: [Item]
    @Binding var draggedItem: Item?
    let isLastItem: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem else { return false }
        
        withAnimation(.snappy) {
            if let sourceIndex = currentItemArray.firstIndex(of: draggedItem) {
                if isLastItem {
                    currentItemArray.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentItemArray.endIndex)
                } else {
                    currentItemArray.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentItemArray.firstIndex(of: item) ?? 0)
                }
            } else if let sourceIndex = otherItemArray.firstIndex(of: draggedItem) {
                otherItemArray.remove(at: sourceIndex)
                let destinationIndex = isLastItem ? currentItemArray.endIndex : (currentItemArray.firstIndex(of: item) ?? 0)
                currentItemArray.insert(draggedItem, at: destinationIndex)
            }
        }
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem else { return }
        
        withAnimation(.snappy) {
            if draggedItem != item {
                if let sourceIndex = currentItemArray.firstIndex(of: draggedItem) {
                    if isLastItem {
                        currentItemArray.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentItemArray.endIndex)
                    } else {
                        currentItemArray.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: currentItemArray.firstIndex(of: item) ?? 0)
                    }
                } else if let sourceIndex = otherItemArray.firstIndex(of: draggedItem) {
                    otherItemArray.remove(at: sourceIndex)
                    let destinationIndex = isLastItem ? currentItemArray.endIndex : (currentItemArray.firstIndex(of: item) ?? 0)
                    currentItemArray.insert(draggedItem, at: destinationIndex)
                }
            }
        }
    }
}

// Novo delegado para gerenciar drop em listas vazias
struct EmptyDropDelegate: DropDelegate {
    @Binding var currentItemArray: [Item]
    @Binding var otherItemArray: [Item]
    @Binding var draggedItem: Item?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem else { return false }
        
        withAnimation(.snappy) {
            if let sourceIndex = otherItemArray.firstIndex(of: draggedItem) {
                otherItemArray.remove(at: sourceIndex)
                currentItemArray.append(draggedItem)
            }
        }
        
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
