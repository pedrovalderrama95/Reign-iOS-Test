//
//  MainViewController.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 30/03/2022.
//

import UIKit
import Alamofire
import SafariServices
import ProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet weak var hackerNewsTableView: UITableView!
    let refreshControl = UIRefreshControl()
    let viewModel = HackerNewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hackerNewsTableView.register(UINib(nibName: "HackerNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "HackerNewsTableViewCell")
        title = "News"

        hackerNewsTableView.delegate = self
        hackerNewsTableView.dataSource = self
        viewModel.delegate = self
        
        // Default animation for Progres Indicator
        ProgressHUD.animationType = .circleStrokeSpin
        
        setupRefreshControl()
        viewModel.getNews()
    }
    
    //Method that is called when a URL is available for the web view. Some cells don't have a URL so it won't do anything.
    func showDetail(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safari = SFSafariViewController(url: url, configuration: config)
        navigationController?.pushViewController(safari, animated: true)
    }
    
    // Method that detects when the table reached the end, if so, it makes the request by increasing the number of pages
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > ((hackerNewsTableView.contentSize.height - 100) - scrollView.frame.size.height)  {
            viewModel.incrementPages()
        }
    }
    
    // Associates a target object refreshControl
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        hackerNewsTableView.refreshControl = refreshControl
    }
    
    // Will request the news again when refreshing the control
    @objc private func refresh() {
        viewModel.getNews()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HackerNewsTableViewCell") as? HackerNewsTableViewCell else { return UITableViewCell() }
        cell.setData(news: viewModel.news[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(urlString: viewModel.news[indexPath.row].storyURL)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNews(index: indexPath)
        }
    }
    
}

extension MainViewController: HackerNewsViewModelDelegate {
    func onDelete(index: IndexPath) {
        hackerNewsTableView.deleteRows(at: [index], with: .fade)
    }
    
    func onFinish() {
        //Remove the refreschControl/ProcessHud when the request is done and refresh the table
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
        hackerNewsTableView.reloadData()
    }
    
    func onError(error: Error) {
        refreshControl.endRefreshing()
        ProgressHUD.dismiss()
        showAlert(title: "Oops!", message: error.localizedDescription)
    }
    
    func onLoad() {
        //Show an indicator while making the request
        ProgressHUD.show("")
        viewModel.isLoadingList = true
    }
    
}
