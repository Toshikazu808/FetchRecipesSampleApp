//
//  RecipeListView.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @EnvironmentObject private var appDelegate: AppDelegate
    @EnvironmentObject private var vm: RecipeListVM
    
    var body: some View {
        GeometryReader { geometry in
            let h = geometry.size.height
            if vm.recipes.isEmpty {
                Text("No available recipes")
                    .accessibilityIdentifier("NoRecipes")
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(vm.recipes.enumerated()), id: \.offset) { i, recipe in
                                Button(action: {
                                    vm.navPath.append(.video(recipe))
                                }, label: {
                                    RecipeView(recipe: recipe, maxHeight: h * 0.12)
                                        .id(i)
                                        .environmentObject(vm)
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onChange(of: vm.recipes.count) { _, _ in
                        proxy.scrollTo(0)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            vm.lazyInit(appDelegate.apiManager)
            Task {
                await vm.fetchRecipes()
            }
        }
        .alert("Alert", isPresented: $vm.fetchError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("An error occurred when fetching the data")
        }
    }
}

#Preview {
    RecipeListView()
}
