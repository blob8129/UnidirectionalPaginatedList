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
    private var loadedSlugs = Set<String>()
    
    init(networkService: NetworkServiceProtocol,
         view: ViewInput?,
         baseUrl: URL,
         decoder: JSONDecoder) {
        self.networkService = networkService
        self.view = view
        self.baseUrl = baseUrl
        self.decoder = decoder
    }
    
    private func load(sucess: @escaping ([Entity]) -> Void) {
        let url = URLBuilder(url: baseUrl)
            .with(paths: "58", "users", "peter-holm", "followers")
            .url
        load(at: url, sucess: sucess)
    }

    private func loadNext(slug: String, sucess: @escaping ([Entity]) -> Void) {
        let url = URLBuilder(url: baseUrl)
            .with(paths: "58", "users", "peter-holm", "followers")
            .with(queries: ["current_follow_slug": slug])
            .url
        load(at: url, sucess: sucess)
    }

    private func load(at url: URL, sucess: @escaping ([Entity]) -> Void) {
        print("[INFO] \(url)")
        networkService.loadData(at: url) { result in
            switch result {
            case .success(let data):
                do {
                    let users = try self.decoder.decode(EntityContainer.self, from: data).response
                    DispatchQueue.main.async {
                        sucess(users)
                    }
                } catch let error {
                    print("[ERROR]❗️ \(error)")
                    DispatchQueue.main.async {
                        self.view?.render(state: .networkError)
                    }
                }
            case .error(_):
                DispatchQueue.main.async {
                    self.view?.render(state: .networkError)

                }
            }
        }
    }
}


extension Interactor: InteractorInput {
    func willDisplayLast(slug: String) {
        guard loadedSlugs.contains(slug) == false else { return }
        loadedSlugs.insert(slug)
        loadNext(slug: slug) { users in
            self.view?.render(state: .loadedNext(users))
        }
    }

    func start() {
        load() { users in
            self.view?.render(state: .loaded(users))
        }
    }
}
