//
//  NewsViewController.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 13/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsArticlesTableView: UITableView!
    
    var articles = [Source.Article]()
    //let fetchData = FetchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsArticlesTableView.delegate = self
        newsArticlesTableView.dataSource = self
        loadData()
    }
    
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    @IBAction func shareSheet(_ sender: UIBarButtonItem) {
        activeShareSheet()
    }
    
    
    fileprivate func loadData() {
        getResults(from: API.topHeadlimesFromSource()! ) {
            DispatchQueue.main.async {
                self.newsArticlesTableView.reloadData()
            }
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
    
    
    //MARK: - Networking
    fileprivate func updateResults(_ data: Data) {
        let decoder = JSONDecoder()
        var errorMessage = ""
        
        decoder.dateDecodingStrategy = .iso8601
        articles.removeAll()
        do {
            let rawFeed = try decoder.decode(Source.self, from: data)
            articles = rawFeed.articles
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
    
    func getResults(from url: URL, completion: @escaping () -> () ) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else { return }
            self.updateResults(data)
            completion()
            }.resume()
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
