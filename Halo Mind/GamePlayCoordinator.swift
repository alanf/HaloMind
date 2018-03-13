//
//  GamePlayCoordinator.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import ReactiveKit
import UIKit


protocol GamePlayCoordinatorDelegate: class {
    func gameEnded(result:NBackResult)
}

class GamePlayCoordinator: GamePlayViewControllerDelegate {
    struct ViewModel {
        let correctAnswer = Property(false)
        let currentImage = Property<UIImage?>(nil)
    }
    
    weak var delegate:GamePlayCoordinatorDelegate?
    let pushViewController:(UIViewController) -> ()
    let game:NBackGame
    let images:Dictionary<String, UIImage>
    
    init(delegate: GamePlayCoordinatorDelegate, pushViewController:@escaping (UIViewController) -> (), game:NBackGame, images:Dictionary<String, UIImage>) {
        self.delegate = delegate
        self.pushViewController = pushViewController
        self.game = game
        self.images = images
    }
    
    var displayTime:TimeInterval? = nil
    
    var currentIndex = 0
    var timer:Timer?
    var viewModel = ViewModel()
    var result = NBackResult()
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "Game") as? GamePlayViewController else { fatalError() }
        vc.configure(delegate: self, viewModel: viewModel)
        pushViewController(vc)
        
        displayTime = Date().timeIntervalSinceReferenceDate
        viewModel.currentImage.value = images[game.stimulii[currentIndex]]
        timer = Timer.scheduledTimer(withTimeInterval: game.timeToAnswer, repeats: true) { [weak self] _ in
            self?.nextRound(timeRanOut: true)
        }
    }
    
    func nextRound(timeRanOut: Bool) {
        timer?.invalidate()
        
        currentIndex += 1
        if currentIndex >= game.stimulii.count {
            // TODO: wrap up
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: game.timeToAnswer, repeats: true) { [weak self] _ in
            self?.nextRound(timeRanOut: true)
        }
        
        guard let _displayTime = displayTime else { fatalError() }
        result.answeredCorrectly.append(timeRanOut ? !game.isCorrectAnswer[currentIndex] : game.isCorrectAnswer[currentIndex])
        
        if !timeRanOut {
            viewModel.correctAnswer.value = result.answeredCorrectly.last ?? false
        }
        
        if timeRanOut {
            result.responseTimes.append(nil)
        } else {
            result.responseTimes.append(Date().timeIntervalSinceReferenceDate - _displayTime)
        }
        
        displayTime = Date().timeIntervalSinceReferenceDate
        viewModel.currentImage.value = images[game.stimulii[currentIndex]]
    }
    
    func didTap() {
        nextRound(timeRanOut: false)
    }
}
