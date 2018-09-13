//
//  Constants.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import Foundation

struct API {
    
    //MARK: - API Key
    static let secretAPIKey = URLQueryItem(name: "apiKey", value: "debbf0c53d1a453d86c219dbde1932c1")
    
    //MARK: - URL EndPoints
    static var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
    static var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    static var sourcesUrl = URLComponents(string: "https://newsapi.org/v2/sources?")
    
    //Result Sorting Order
    enum SortOptions: String {
        case relevancy // articles more closely related to q come first.
        case popularity // articles from popular sources and publishers come first.
        case publishedAt //newest articles come first.
    }
    
    //Some date formatting shit
    //    let date = Date()
    //    let dateFormatter = DateFormatter()
    //
    //    func configDate() -> String {
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //        let result = dateFormatter.string(from: date)
    //        return "\(result)"
    //    }
    
    //API Query Parameters
    /// Needs variables that will store the values so they can be changed
    static let search = URLQueryItem(name: "q", value: "uber")
    static let fromDate = URLQueryItem(name: "from", value: "2018-07-17")  // needs to be converted to Date
    static let toDate = URLQueryItem(name: "to", value: "2018-07-18") // needs to be converted to Date
    static let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue)
    static let language = URLQueryItem(name: "language", value: "en")
    static let country = URLQueryItem(name: "country", value: "de")
    static let category = URLQueryItem(name: "category", value: "business")
    static let pageSize = URLQueryItem(name: "pageSize", value: "5")
    static let sourcesName = URLQueryItem(name: "sources", value: "business-insider")
//    static let sourcesName = URLQueryItem(name: "sources", value: "bbc-news") ///needs custom list
    
    static func topHeadlimesFromSource() -> URL? {
        //        topHeadLinesUrl?.queryItems?.append(search)
        //        topHeadLinesUrl?.queryItems?.append(language)
        //        topHeadLinesUrl?.queryItems?.append(fromDate)
        //        topHeadLinesUrl?.queryItems?.append(toDate)
        //        topHeadLinesUrl?.queryItems?.append(sortBy)
        //        topHeadLinesUrl?.queryItems?.append(secretAPIKey)
        API.topHeadLinesUrl?.queryItems?.append(API.sourcesName)
        //        topHeadLinesUrl?.queryItems?.append(country)
                topHeadLinesUrl?.queryItems?.append(pageSize)
        //        topHeadLinesUrl?.queryItems?.append(category)
        API.topHeadLinesUrl?.queryItems?.append(API.secretAPIKey)
        return API.topHeadLinesUrl?.url
    }
    
    func getEverything() -> URL? {
        API.everythingUrl?.queryItems?.append(API.search)
        API.everythingUrl?.queryItems?.append(API.language)
        API.everythingUrl?.queryItems?.append(API.fromDate)
        API.everythingUrl?.queryItems?.append(API.toDate)
        API.everythingUrl?.queryItems?.append(API.sortBy)
        API.everythingUrl?.queryItems?.append(API.secretAPIKey)
        return API.everythingUrl?.url
    }
}
