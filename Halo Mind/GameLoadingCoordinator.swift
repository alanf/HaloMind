//
//  GameLoadingCoordinator.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import ReactiveKit
import UIKit

protocol GameLoadingCoordinatorDelegate: class {
    func didStartGame(game:NBackGame, images:Dictionary<String, UIImage>)
}

class GameLoadingCoordinator: GameLoadingViewControllerDelegate {
    struct ViewModel {
        let enableStartButton = Property(false)
    }
    
    weak var delegate:GameLoadingCoordinatorDelegate?
    let pushViewController:(UIViewController) -> ()
    
    init(delegate: GameLoadingCoordinatorDelegate, pushViewController:@escaping (UIViewController) -> ()) {
        self.delegate = delegate
        self.pushViewController = pushViewController
    }

    var game:NBackGame?
    var images:Dictionary<String, UIImage>?
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "Loading") as? GameLoadingViewController else { fatalError() }
        let viewModel = ViewModel()
        vc.configure(delegate: self, viewModel: viewModel)
        pushViewController(vc)
            
        DispatchQueue.global().async { [weak self] in
            let description = NBackGameDescription()
            self?.game = NBackGame(description: description)
            var images = Dictionary<String, UIImage>()
            for image in description.imageNames {
                images[image] = UIImage(named: image)
            }
            self?.images = images
            
            viewModel.enableStartButton.value = true
        }
    }
    
    func didTapStartButton() {
        guard let game = game, let images = images else {
            fatalError()
        }
        delegate?.didStartGame(game: game, images: images)
    }
}
