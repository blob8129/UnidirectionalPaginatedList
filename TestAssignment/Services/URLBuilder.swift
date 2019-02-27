//
//  URLBuilder.swift
//  Dashboard
//
//  Created by Andrey Volobuev on 22/01/2017.
//  Copyright © 2017 WhiteSoft. All rights reserved.
//
import Foundation


public struct URLBuilder {
    
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }

    func with(queries: [String: String]) -> URLBuilder {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        if components?.queryItems == nil {
            components?.queryItems = queryItems
        } else {
            components?.queryItems?.append(contentsOf: queryItems)
        }
        
        guard let urlComponents = components, let constructedUrl = urlComponents.url else {
            fatalError("Unconstructable componets of \(url)")
        }
        
        return URLBuilder(url: constructedUrl)
    }
    
    func with(paths: String...) -> URLBuilder {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        paths.forEach { pathComponent in
            components?.path += "/\(pathComponent)"
        }
        
        guard let constructedUrl = components?.url else {
            fatalError("Unconstructable componets of \(url)")
        }
        
        return URLBuilder(url: constructedUrl)
    }
}
