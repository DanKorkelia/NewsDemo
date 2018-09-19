//
//  TodayViewController.swift
//  TopHeadline
//
//  Created by Dan Korkelia on 15/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private var articles: [Article] = []
    private let networkService = NetworkService()
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    fileprivate func hideLabels() {
        sourceLabel.alpha = 0.0
        headlineLabel.alpha = 0.0
        imageLabel.alpha = 0.0
    }
    fileprivate func showLabels() {
        sourceLabel.alpha = 1.0
        headlineLabel.alpha = 1.0
        imageLabel.alpha = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var source = "bbc-news"
        let pageSize = "1"
        
        if let currentSource = sharedUserDefaults?.getSource() {
            source = currentSource
        } else {
            source = "bbc-news"
        }
        
        networkService.getResults(newsSource: source, pageSize: pageSize) { results, errorMessage in
            let resultNumber = 0
            if let results = results {
                self.articles = results
                self.sourceLabel.text = self.articles[resultNumber].source.name
                self.headlineLabel.text = self.articles[resultNumber].title
                
                DispatchQueue.global(qos: .userInitiated).async {
                    let data = try? Data(contentsOf: self.articles[resultNumber].urlToImage! )
                    let myimage = UIImage(data: data!)
                    DispatchQueue.main.sync {
                        self.imageLabel.image = myimage
                        self.showLabels()
                    }
                }
                
            }
            if !errorMessage.isEmpty { print("Error message: " + errorMessage) }
        }

    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
