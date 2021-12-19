//
//  WebViewController.swift
//  LoginScreen
//
//  Created by  Paul on 18.12.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Public vars
    
    var url: URL? {
        didSet {
            if view.window != nil {
                fetchWebPage()
            }
        }
    }
    
    // MARK: - Private vars
    
    private var webView: WKWebView!
    private var progressView = UIProgressView(progressViewStyle: .default)
    
    // MARK: - Initializers
    
    deinit {
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
    }
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton]
        
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if url != webView.url {
            fetchWebPage()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(WKWebView.estimatedProgress):
            progressView.progress = Float(webView.estimatedProgress)
        case #keyPath(WKWebView.isLoading):
            navigationController?.isToolbarHidden = !webView.isLoading
        default:
            break
        }
    }
    
    
    // MARK: - Private funcs
    
    private func fetchWebPage() {
        if let url = url {
             webView.load(URLRequest(url: url))
        } else {
           // TODO: Clear `webView`. Something like:
           // webView.url = nil
        }
    }
}
