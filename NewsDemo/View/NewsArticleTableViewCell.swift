//
//  NewsArticleTableViewCell.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import UIKit

class NewsArticleTableViewCell: UITableViewCell {

    //MARK: - Storyboard
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    func updateCell(with headlines: Source.Article) {
        sourceLabel.text = headlines.source.name
        headlineLabel.text = headlines.title
        
        ///default image in case of error or missing image.
        let errorURL = URL(string: "https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png")
        
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: headlines.urlToImage ?? errorURL! )
            DispatchQueue.main.async {
                self.imageLabel.image = UIImage(data: data!)
            }
        }
    }
}
