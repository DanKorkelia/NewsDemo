//
//  NetworkService.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import Foundation

class NetworkService {
    
    //MARK: - Properties
    typealias QueryResult = ([Article]?, String) -> ()
    var articles: [Article] = []
    var errorMessage = ""
    
    //MARK: - Setup Connection
    lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    
    
    //MARK: - Fetch Data
    func getResults(newsSource: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        guard var urlComponents = URLComponents(string: "https://newsapi.org/v2/top-headlines?") else { return }
        
        urlComponents.query = "sources=\(newsSource)&pageSize=20&apiKey=debbf0c53d1a453d86c219dbde1932c1"
        guard let url = urlComponents.url else { return }
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {

                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self.updateResults(data)
                DispatchQueue.main.async {
                    completion(self.articles, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
    
    
    func updateResults(_ data: Data) {
        decoder.dateDecodingStrategy = .iso8601
        articles.removeAll()
        do {
            let feed = try decoder.decode(Source.self, from: data)
            articles = feed.articles
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
}
