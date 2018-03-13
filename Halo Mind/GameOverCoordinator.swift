//
//  GameOVerCoordinator.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import UIKit

protocol GameOverCoordinatorDelegate: class {
    func didTapRestart()
}

class GameOverCoordinator: GameOverViewControllerDelegate {
    weak var delegate:GameOverCoordinatorDelegate?
    let pushViewController:(UIViewController) -> ()
    let gameResult:NBackResult
    
    struct ViewModel {
        let scoreDescription:String
        let reactionTimes:String
    }
    
    init(delegate: GameOverCoordinatorDelegate, pushViewController:@escaping (UIViewController) -> (), gameResult:NBackResult) {
        self.delegate = delegate
        self.pushViewController = pushViewController
        self.gameResult = gameResult
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "WrapUp") as? GameOverViewController else { fatalError() }
        
        let correct = gameResult.answeredCorrectly.filter { $0 }.count
        let response = gameResult.responseTimes.flatMap { if let v = $0 {
            return String(v)
        } else {
            return nil
            }
            }.joined(separator: " ")
        debugPrint("Reaction times \(response)")
        
        let viewModel = ViewModel(scoreDescription: "\(correct) / \(gameResult.answeredCorrectly.count)", reactionTimes: "")
        vc.configure(delegate: self, viewModel: viewModel)
        pushViewController(vc)
    }
    
    func didTapRestart() {
        delegate?.didTapRestart()
    }
}
