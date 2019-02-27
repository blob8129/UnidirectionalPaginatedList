//
//  Interactor.swift
//  EFWeatherApp
//
//  Created by Andrey Volobuev on 12/7/18.
//  Copyright © 2018 blob8129. All rights reserved.
//

import Foundation

final class Interactor {
    weak var view: ViewInput?
    private let networkService: NetworkServiceProtocol
    private let baseUrl: URL
    private var currentReport: Entity?
    private let decoder: JSONDecoder
    
    init(networkService: NetworkServiceProtocol,
         view: ViewInput?,
         baseUrl: URL,
         decoder: JSONDecoder) {
        self.networkService = networkService
        self.view = view
        self.baseUrl = baseUrl
        self.decoder = decoder
    }
    
    private func load() {
        let url = URLBuilder(url: baseUrl).with(queries: [
            "appid": "b6907d289e10d714a6e88b30761fae22"
        ]).url
        print("[INFO] \(url)")
        networkService.loadData(at: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
               //     let weather = try self?.decoder.decode(WeatherReport.self, from: data)
                    DispatchQueue.main.async {
                 //       self?.view?.render(state: .loadedFromTheNetwork(currentReport))
                    }
                } catch let error {
                    print("[ERROR]❗️ \(error)")
                    DispatchQueue.main.async {
                        self?.view?.render(state: .networkError)
                    }
                }
            case .error(_):
                DispatchQueue.main.async {
                    self?.view?.render(state: .networkError)

                }
            }
        }
    }
}


extension Interactor: InteractorInput {
    func start() {

    }
}
