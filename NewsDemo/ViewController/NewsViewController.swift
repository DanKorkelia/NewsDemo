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
    private var currentSource = ""
    private let sourceOne = "the-verge"
    private let sourceTwo = "techcrunch"
    private let pageSize = "20"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlesTable.delegate = self
        articlesTable.dataSource = self
        loadData(source: sourceOne)
        sharedUserDefaults?.setSource(value: sourceOne)
        sharedUserDefaults?.synchronize()
    }
    
    @IBAction func setSourceTwo(_ sender: UIBarButtonItem) {
        sharedUserDefaults?.setSource(value: sourceTwo)
        sharedUserDefaults?.synchronize()
        loadData(source: sourceTwo)
    }
    @IBAction func setSourceOne(_ sender: UIBarButtonItem) {
        sharedUserDefaults?.setSource(value: sourceOne)
        sharedUserDefaults?.synchronize()
        loadData(source: sourceOne)
    }
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        loadData(source: currentSource)
    }
    @IBAction func shareSheet(_ sender: UIBarButtonItem) {
        activeShareSheet()
    }
    
    
    fileprivate func loadData(source: String) {
        currentSource = source
        
        networkService.getResults(newsSource: source, pageSize: pageSize) { results, errorMessage in
            if let results = results {
                self.articles = results
                self.articlesTable.reloadData()
            }
            if !errorMessage.isEmpty { print("Error message: " + errorMessage) }
        }
    }
    
    //MARK: - Activity Sheet
    fileprivate func activeShareSheet() {
        let activity = UIActivityViewController(activityItems: [makeList()], applicationActivities: [])
        activity.popoverPresentationController?.sourceView = self.view
        
        activity.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.mail]
        
        present(activity, animated: true)
    }
    
    /// This helps format the output to look nicer with Notes App.
    fileprivate func makeList() -> String {
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

