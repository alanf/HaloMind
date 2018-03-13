//
//  GamePlayViewController.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit

protocol GamePlayViewControllerDelegate:class {
    func didTap()
}

class GamePlayViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var correctLabel: UILabel!
    
    weak var delegate:GamePlayViewControllerDelegate?
    var viewModel:GamePlayCoordinator.ViewModel?
    func configure(delegate: GamePlayViewControllerDelegate, viewModel: GamePlayCoordinator.ViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
    @IBAction func didTap(_ sender: Any) {
        delegate?.didTap()
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { fatalError() }
        super.viewDidLoad()
        
        viewModel.currentImage.observeOn(DispatchQueue.main).observeNext { [weak self] image in
            self?.imageView.image = image
            self?.imageView.alpha = 0.50
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.imageView.alpha = 1.0
            }
        }.dispose(in: bag)
        
        viewModel.correctAnswer.skip(first: 1).observeOn(DispatchQueue.main).observeNext { [weak self] correct in
            if correct {
                self?.correctLabel.text = "Correct"
                self?.correctLabel.textColor = .green
            } else {
                self?.correctLabel.text = "Incorrect"
                self?.correctLabel.textColor = .red
            }
            self?.correctLabel.alpha = 1.0
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.correctLabel.alpha = 0.0
            }
        }.dispose(in: bag)
    }
}
