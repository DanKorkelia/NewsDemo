//
//  NewsViewController.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var articlesTable: UITableView!
    var articles: [Article] = []
    let networkService = NetworkService()
    
    //MARK: - Constants
    var currentSource = ""
    let bbc = "bbc-news"
    let techcrunch = "techcrunch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlesTable.delegate = self
        articlesTable.dataSource = self
        loadData(source: bbc)
    }
    
    @IBAction func loadTechCrunch(_ sender: UIBarButtonItem) {
        loadData(source: techcrunch)
    }
    @IBAction func loadBBC(_ sender: UIBarButtonItem) {
        loadData(source: bbc)
    }
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        loadData(source: currentSource)
    }
    @IBAction func shareSheet(_ sender: UIBarButtonItem) {
        activeShareSheet()
    }
    
    
    fileprivate func loadData(source: String) {
        currentSource = source
        networkService.getResults(newsSource: source) { results, errorMessage in
            if let results = results {
                self.articles = results
                self.articlesTable.reloadData()
            }
            if !errorMessage.isEmpty { print("Error message: " + errorMessage) }
        }
        
    }
    
    func activeShareSheet() {
        let activity = UIActivityViewController(activityItems: [makeList()], applicationActivities: [])
        activity.popoverPresentationController?.sourceView = self.view
        
        activity.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.mail]
        present(activity, animated: true)
    }
    
    /// This helps format the output of the array to fit Notes and Messages App.
    func makeList() -> String {
        var list = """
        Top 10 Headlines

        """
        
        var counter = 1
        for article in articles {
            list.append("\(counter) - " + "\(article.title!) " + "\(article.author!)" + "\n")
            counter += 1
        }
        return list
    }
    
}

//MARK: - Table View Extension
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News Article Cell") as! NewsArticleTableViewCell
        let article = articles[indexPath.row]
        cell.updateCell(with: article)
        return cell
    }
}
