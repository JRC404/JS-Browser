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
        refresh.tintColor = JS;
        share.tintColor = JS;
        toolbarItems = [progressButton,spacer, share, spacer, refresh]
        navigationController?.isToolbarHidden = false
        let url = URL(string: "https://wearecodenation.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func navigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(openTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem?.tintColor = JS;
        navigationItem.leftBarButtonItem?.tintColor = JS;
        
        navigationController?.hidesBarsOnSwipe = true


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
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "github.com/jrc404", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "google.co.uk", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        ac.view.tintColor = JS;
        present(ac, animated: true)
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

}
