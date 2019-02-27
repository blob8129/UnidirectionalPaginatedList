//
//  Protocol.swift
//  EFWeatherApp
//
//  Created by Andrey Volobuev on 12/7/18.
//  Copyright © 2018 blob8129. All rights reserved.
//
import Foundation

protocol InteractorInput {
    func start()
}

protocol ViewInput: class {
    func render(state: ViewState)
}

enum ViewState: Equatable {
    case loaded([Entity])
    case networkError
}

protocol DateProvider {
    var date: Date { get }
}
