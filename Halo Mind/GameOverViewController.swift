//
//  GameOverViewController.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import UIKit

protocol GameOverViewControllerDelegate: class {
    func didTapRestart()
}

class GameOverViewController: UIViewController {
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var reactionTimesLabel: UILabel!
    
    weak var delegate:GameOverViewControllerDelegate?
    var viewModel:GameOverCoordinator.ViewModel?
    func configure(delegate: GameOverViewControllerDelegate, viewModel: GameOverCoordinator.ViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = viewModel?.scoreDescription
        reactionTimesLabel.text = viewModel?.reactionTimes
    }
    
    @IBAction func didTapPlayAgain(_ sender: Any) {
        delegate?.didTapRestart()
    }
}
