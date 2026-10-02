//
//  AddItemView.swift
//  ShoppingList
//
//  Created by Martine Hagberg on 28/09/2026.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    
    //Environment er et sett ed delte verdier som views kan lese
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var quanity = 1
    @State private var category: ShoppingCategory = .fruit
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Varer"){
                    TextField("Hva trenger du?", text: $name)
                }
                
                Section("Detaljer"){
                    Picker("Kategori", selection: $category) {
                        ForEach(ShoppingCategory.allCases, id:\.self){
                            category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    
                    Stepper(
                        "Antall: \(quanity)",
                        value: $quanity,
                        in: 1...20
                    )
                }
                
            }
            .navigationTitle("Legg til")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lagre") {
                        addItem()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func addItem(){
        let newItem = ShoppingItem(name: name, quantity: quanity, category: category)
        
        modelContext.insert(newItem)
        dismiss()
    }
}

#Preview {
    AddItemView()
}
