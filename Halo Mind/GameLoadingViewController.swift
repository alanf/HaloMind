//
//  GameLoadingViewController.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

protocol GameLoadingViewControllerDelegate:class {
    func didTapStartButton()
}

class GameLoadingViewController: UIViewController {
    @IBOutlet private weak var startGameButton: UIButton!
    private weak var delegate:GameLoadingViewControllerDelegate?
    private var viewModel: GameLoadingCoordinator.ViewModel?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configure(delegate:GameLoadingViewControllerDelegate, viewModel: GameLoadingCoordinator.ViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { fatalError() }
        viewModel.enableStartButton.bind(to: startGameButton.reactive.isEnabled).dispose(in: bag)
    }
    
    @IBAction func didTapStartButton(_ sender: Any) {
        delegate?.didTapStartButton()
    }
}

