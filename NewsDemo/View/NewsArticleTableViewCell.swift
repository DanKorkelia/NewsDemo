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
    
    func updateCell(with headlines: Article) {
        sourceLabel.text = headlines.source.name
        headlineLabel.text = headlines.title
                
            DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: headlines.urlToImage ?? errorURL! )
                let myimage = UIImage(data: data!)
            DispatchQueue.main.sync {
                self.imageLabel.image = myimage
            }
        }
    }
}
