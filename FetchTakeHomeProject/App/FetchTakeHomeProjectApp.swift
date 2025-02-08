//
//  FetchTakeHomeProjectApp.swift
//  FetchTakeHomeProject
//
//  Created by Ryan Kanno on 2/6/25.
//

import SwiftUI
import SwiftData

@main
struct FetchTakeHomeProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: CachedRecipe.self)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContainer.mainContext)
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var apiManager: ApiCallable!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupDependencies()
        return true
    }
    
    func setupDependencies() {
        if CommandLine.arguments.contains(where: { $0.contains("-UITests") }) {
            self.apiManager = MockApi()
        } else {
            self.apiManager = Api()
        }
    }
}
