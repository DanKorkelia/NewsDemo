//
//  FetchData.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import Foundation

//class FetchData {
//    
//    //MARK: - Networking
//    let decoder = JSONDecoder()
//    var articles = [Source.Article]()
//    var errorMessage = ""
//    
//    fileprivate func updateResults(_ data: Data) {
//        decoder.dateDecodingStrategy = .iso8601
//        articles.removeAll()
//        do {
//            let rawFeed = try decoder.decode([Source.Article].self, from: data)
//            articles = rawFeed
//        } catch let decodeError as NSError {
//            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
//            return
//        }
//    }
//    
//    func getResults(from url: URL, completion: @escaping () -> () ) {
//        URLSession.shared.dataTask(with: url) { (data, response, error ) in
//            guard let data = data else { return }
//            self.updateResults(data)
//            completion()
//            }.resume()
//    }
//}
