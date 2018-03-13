//
//  NBackGame.swift
//  Halo Mind
//
//  Created by Alan Fineberg on 3/13/18.
//  Copyright © 2018 Halo Neuro. All rights reserved.
//

import Foundation

struct NBackGameDescription {
    let n = 2
    let count = 40
    // TODO: enum to describe stimulus
    let imageNames = ["cat", "shoe", "heart", "fish", "spoon", "shoe"]
    let timeToAnswer: TimeInterval = 2.0
}

struct NBackGame {
    let stimulii:[String]
    let isCorrectAnswer:[Bool]
    let timeToAnswer:TimeInterval
    
    init(description:NBackGameDescription) {
        self.timeToAnswer = description.timeToAnswer
        var images = [String]()
        var correct = [false]
        for i in 0...description.count {
            let idx = Int(arc4random()) % description.imageNames.count
            images.append(description.imageNames[idx])
            if i >= description.n {
                 correct.append(images[i - description.n] == images[i])
                debugPrint("\(images[i]) == \(images[i - description.n])? \(correct.last)")
            } else {
                correct.append(false)
                debugPrint("false")
            }
        }
        stimulii = images
        isCorrectAnswer = correct
    }
}

struct NBackResult {
    var answeredCorrectly:[Bool] = []
    var responseTimes:[TimeInterval?] = []
}
