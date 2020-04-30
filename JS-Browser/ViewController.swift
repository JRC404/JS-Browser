//
//  ViewController.swift
//  JS-Browser
//
//  Created by Jacob Reilly-Cooper on 16/04/2020.
//  Copyright © 2020 Janapexo Studios. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var progressButton: UIBarButtonItem!
    let searchBar = UISearchBar()

   
    
    let JS = UIColor(red: 255/255.0, green: 0/255.0, blue: 56/255.0, alpha: 1)

    
    override func loadView() {
        webView = WKWebView()
        // fix for error is to promise to implement WKNavigationDelegate protocol
        webView.navigationDelegate = self
        view = webView
    }
    
    func browserSetUp() {
        navigationBar()
        progressIndicator()
        
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMe(sender:)))
//        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-left"), style: .plain, target: self, action: #selector(back(sender:)))
        let forward = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow-right"), style: .plain, target: self, action: #selector(forward(sender:)))
        let bookmark = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: nil)
        refresh.tintColor = JS;
        share.tintColor = JS;
        forward.tintColor = JS;
        back.tintColor = JS;
        bookmark.tintColor = JS;
        toolbarItems = [back, spacer, forward, spacer, share, spacer, bookmark, spacer, refresh]
        navigationController?.isToolbarHidden = false
        let url = URL(string: "https://wearecodenation.com")!
        refreshPull()
        searchBar.text = url.absoluteString
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func navigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(openTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style: .plain, target: self, action: #selector(openTapped))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        searchBarFunc()
        navigationItem.rightBarButtonItem?.tintColor = JS;
//        navigationItem.leftBarButtonItem?.tintColor = JS;
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func searchBarFunc() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search or enter website name"
        searchBar.tintColor = JS;
        searchBar.keyboardType = UIKeyboardType.URL
        searchBar.autocapitalizationType = .none
        
        
//        let url = URL(string: "https://" + (searchBar.text ?? "google.com"))!
//        self.webView.load(URLRequest(url: url))
//        searchBar.becomeFirstResponder()
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    func progressIndicator() {
        progressView = UIProgressView(progressViewStyle: .default)
//        progressView.siz
        progressButton = UIBarButtonItem(customView: progressView)
        progressView.progressTintColor = JS;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        browserSetUp()
//        notifications()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc func searchTapped() {
        var bookmarks = [URL]()
        let alert = UIAlertController(title: "Enter your URL", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = JS;
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your URL here"
        })
        
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { action in
            let url = URL(string: "https://" + (alert.textFields?.first?.text ?? "google.com"))!
            self.webView.load(URLRequest(url: url))
            print(url as Any)
//            var bookmarks = [URL]()
            bookmarks.append(url)
            print("You have saved \(bookmarks.count) bookmark.")
            //            if url == alert.textFields?.first?.text {
            //            print("Your URL was: \(url ?? "no url found")")
            //            }
        }))
    
        self.present(alert, animated: true)
    }
    
    
    @objc func openTapped() {
        let url = URL(string: "https://github.com/jrc404")!
        searchBar.text = url.absoluteString
        webView.load(URLRequest(url: url))
//        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "github.com/jrc404", style: .default, handler: openPage))
//        ac.addAction(UIAlertAction(title: "google.co.uk", style: .default, handler: openPage))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//        ac.view.tintColor = JS;
//        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    
    @objc func shareMe(sender: UIBarButtonItem) {
        let text = webView.url
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    @objc func back(sender: UIBarButtonItem) {
        if(webView.canGoBack) {
             webView.goBack()
        } else {
             self.navigationController?.popViewController(animated:true)
        }
    }
    
    func refreshPull() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        webView.scrollView.addSubview(refreshControl)
        webView.scrollView.bounces = true
    }
    
    @objc func forward(sender: UIBarButtonItem) {
        if(webView.canGoForward) {
             webView.goForward()
        } else {
             self.navigationController?.popViewController(animated:true)
        }
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        webView?.reload()
        sender.endRefreshing()
    }
    
//    func notifcation() {
//        let notification = UILocalNotification()
//        notification.alertBody = "Hello, local notifications!"
//        notification.fireDate = NSDate().dateByAddingTimeInterval(10) as Date // 10 seconds after now UIApplication.sharedApplication().scheduleLocalNotification(notification)
//    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
//        print("\(searchText)")
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var url: URL!
        url = URL(string: "\(searchBar.text ?? "https://google.com")")!
        let something = url.absoluteString
        print(url!)
        let check = something.contains("https://")
        if (!check) {
            print("idiot")
            url = URL(string: "https://" + (searchBar.text ?? "https://google.com"))!
        
        }
       
//        searchBar.placeholder = "Search or enter website name"

        searchBar.text = url.absoluteString
        self.webView.load(URLRequest(url: url))
        searchBar.resignFirstResponder()
    }
}

