//
//  Builder.swift
//  EFWeatherApp
//
//  Created by Andrey Volobuev on 12/7/18.
//  Copyright © 2018 blob8129. All rights reserved.
//
import UIKit

final class Builder {
    func build() -> UIViewController {
        let baseUrl = URL(string: "https://api.tonsser.com")!
        let networkService = NetworkService()
        let viewController = ViewController()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let interactor = Interactor(networkService: networkService,
                                    view: viewController,
                                    baseUrl: baseUrl,
                                    decoder: decoder)
        
        viewController.interactor = interactor
        return viewController
    }
}
