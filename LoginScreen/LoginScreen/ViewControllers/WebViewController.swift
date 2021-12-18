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
    
    var webView: WKWebView!
    
    // MARK: - Initializers
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if url != webView.url {
            fetchWebPage()
        }
    }
    
    // MARK: - @IBActions
    
    // MARK: - Public funcs
    
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
