//
//  ContentView.swift
//  ShoppingList
//
//  Created by Martine Hagberg on 28/09/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var selectedFilter: Shoppingfilter = .all
    @State private var showingAddItem = false
    
    @Query(
        sort: \ShoppingItem.createdAt,
        order: .reverse
    )
    private var items: [ShoppingItem]
    
    private var filteredItems: [ShoppingItem] {
        
        //filtrer ut alle varer som matcher søkeord
        let searchedItems = items.filter { item in
            searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
        }
        
        //Filtrerer ut alle varene som hacr valgt selectedFilter
        switch selectedFilter {
        case .all:
            return searchedItems
        case .missing:
            return searchedItems.filter { !$0.isBought }
        case .bought:
            return searchedItems.filter { $0.isBought }
        }
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(Shoppingfilter.allCases, id: \.self){ filter in
                        Text(filter.rawValue)
                            .tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List{
                    
                    ForEach(ShoppingCategory.allCases, id: \.self){ category in
                        let categoryItems = filteredItems.filter {
                            $0.category == category
                        }
                        
                        // Hvis kategorien har varer
                        if !categoryItems.isEmpty {
                            Section (category.rawValue) {
                                ForEach(categoryItems) { item in
                                
                                    HStack {
                                        Button {
                                            
                                            withAnimation(.snappy) {
                                                item.isBought.toggle()
                                            }
                                            
                                        } label: {
                                            Image(systemName: item.isBought ? "checkmark.circle.fill" : "circle")
                                                .contentTransition(.symbolEffect(.replace))
                                        }
                                        .buttonStyle(.plain)
                                        .sensoryFeedback(.selection, trigger: item.isBought)
                                        
                                        VStack(alignment: .leading){
                                            Text(item.name)
                                                .strikethrough(item.isBought)
                                            
                                            Text("\(item.category.rawValue)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(item.quantity) stk")
                                        
                                    }
                                    .opacity(item.isBought ? 0.5 : 1.0)
                                }
                                .onDelete(perform: deleteItems)
                                
                            }
                        }
                    }
                }
            }
            .navigationTitle("Handleliste")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView()
            }
            .searchable(text: $searchText, prompt: "Søk etter varer")
            
        }
    }
    
    private func deleteItems(at offsets: IndexSet){
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}
