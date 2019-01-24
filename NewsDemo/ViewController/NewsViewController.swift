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
    
    private var currentSource = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlesTable.delegate = self
        articlesTable.dataSource = self
        loadData(source: Constants.sourceOne)
        sharedUserDefaults?.setSource(value: Constants.sourceOne)
        sharedUserDefaults?.synchronize()
    }
    
    @IBAction func setSourceTwo(_ sender: UIBarButtonItem) {
        sharedUserDefaults?.setSource(value: Constants.sourceTwo)
        sharedUserDefaults?.synchronize()
        loadData(source: Constants.sourceTwo)
    }
    @IBAction func setSourceOne(_ sender: UIBarButtonItem) {
        sharedUserDefaults?.setSource(value: Constants.sourceOne)
        sharedUserDefaults?.synchronize()
        loadData(source: Constants.sourceOne)
    }
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        loadData(source: currentSource)
    }
    @IBAction func shareSheet(_ sender: UIBarButtonItem) {
        activeShareSheet()
    }
    
    
    fileprivate func loadData(source: String) {
        currentSource = source
        
        networkService.getResults(newsSource: source, pageSize: Constants.pageSize) { results, errorMessage in
            if let results = results {
                self.articles = results
                self.articlesTable.reloadData()
            }
            if !errorMessage.isEmpty { print("Error message: " + errorMessage) }
        }
    }
    
    //MARK: - Activity Sheet
    fileprivate func activeShareSheet() {
        let activity = UIActivityViewController(activityItems: [createOrderedList()], applicationActivities: [])
        activity.popoverPresentationController?.sourceView = self.view
        
        activity.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.openInIBooks, UIActivity.ActivityType.mail]
        
        present(activity, animated: true)
    }
    
    /// This helps format the output to look nicer with Notes App.
    fileprivate func createOrderedList() -> String {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCell) as! NewsArticleTableViewCell
        let article = articles[indexPath.row]
        cell.updateCell(with: article)
        return cell
    }
}
