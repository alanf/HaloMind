//
//  AppCoordinator.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator:GameLoadingCoordinatorDelegate, GamePlayCoordinatorDelegate {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    var gameLoadingCoordinator:GameLoadingCoordinator?
    var gamePlayCoordinator: GamePlayCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        if let userID = UserDefaults.standard.object(forKey: "userID") {
            // get config from server
            
        } else {
            let userID = UUID().uuidString
            UserDefaults.standard.set(userID, forKey: "userID")
        }
        
        let navRootViewController = UIViewController()
        navRootViewController.view.backgroundColor = UIColor.blue
        navigationController.pushViewController(navRootViewController, animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        
        gameLoadingCoordinator = GameLoadingCoordinator(delegate: self, pushViewController: pushViewController)
        gameLoadingCoordinator?.start()
    }
    
    private func pushViewController(viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.show(viewController, sender: self)
        }
    }
    
    func didStartGame(game:NBackGame, images:Dictionary<String, UIImage>) {
        gameLoadingCoordinator = nil
        
        gamePlayCoordinator = GamePlayCoordinator(delegate: self, pushViewController: pushViewController, game: game, images: images)
        gamePlayCoordinator?.start()
    }
    
    func gameEnded(result:NBackResult) {
        
    }
}
