//
//  NetworkService.swift
//  UsersPosts
//
//  Created by Andrey Volobuev on 8/6/18.
//  Copyright © 2018 blob8129. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func loadData(at url: URL, callBack: @escaping (DownloadResult<Data>) -> ())
}

protocol SessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}

protocol DataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: DataTaskProtocol {}
extension URLSession: SessionProtocol {}

enum NetworkError<T>: Error {
    case unknown
    case sessionError(Error)
    case nonHTTPResponse(response: URLResponse)
    case httpRequestFailed(response: HTTPURLResponse, data: T)
}

extension NetworkError: Equatable {
    static func ==(lhs: NetworkError<T>, rhs: NetworkError<T>) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.nonHTTPResponse(let respLhs), .nonHTTPResponse(let respRhs)):
            return respLhs == respRhs
        case (.httpRequestFailed(let respLhs, _), .httpRequestFailed(let respRhs, _)):
            return respLhs == respRhs
        case (.sessionError(let lhsError), .sessionError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

enum DownloadResult<T> {
    case success(T)
    case error(NetworkError<T>)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: SessionProtocol
    
    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }

    func loadData(at url: URL, callBack: @escaping (DownloadResult<Data>) -> ()) {
        let task = session.dataTask(with: url) { loadedUrl, response, error in
            self.chekResult(item: loadedUrl, response: response, error: error, callBack: callBack)
        }
        task.resume()
    }

    private func chekResult<T>(item: T?,
                               response: URLResponse?,
                               error: Error?,
                               callBack: (DownloadResult<T>) -> ()) {
        
        guard let item = item, let response = response else {
            callBack(error != nil ? .error(.sessionError(error!)) : .error(.unknown))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            callBack(DownloadResult.error(.nonHTTPResponse(response: response)))
            return
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            callBack(.error(.httpRequestFailed(response: httpResponse, data: item)))
            return
        }
        callBack(.success(item))
    }
}
