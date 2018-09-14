//
//  NewsModel.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import Foundation

//Remote API Structure
struct Source: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date
    
    struct Source: Codable {
        let id: String?
        let name: String?
    }
}
