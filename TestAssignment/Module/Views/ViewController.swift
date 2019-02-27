//
//  ViewController.swift
//  EFWeatherApp
//
//  Created by Andrey Volobuev on 12/4/18.
//  Copyright © 2018 blob8129. All rights reserved.
//
import UIKit

final class ViewController: UIViewController {

    var interactor: InteractorInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactor?.start()
    }
    
    func addAllSubviews() {
        NSLayoutConstraint.activate([

        ])
    }

    private func display(_ report: Entity) {

    }
}

extension ViewController: ViewInput {
    func render(state: ViewState) {
        switch state {
        default:
            break
        }
    }
}
