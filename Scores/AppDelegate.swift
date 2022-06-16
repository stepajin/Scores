//
//  AppDelegate.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: AppRouter = { AppRouter(window: window!) }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        setupDependencyInjection()
        router.start()
        return true
    }
    
    private func setupDependencyInjection() {
        DI.container.register(APIConfiguration.self) { _ in .v4 }
        DI.container.register(APIService.self) { _ in
            CachingService()
        }.inObjectScope(.container)
    }
}

