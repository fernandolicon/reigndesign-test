//
//  EntryWebViewController.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 1/10/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit

class EntryWebViewController: UIViewController, UIWebViewDelegate {
    
    var entryUrlString = ""
    let progressView = ViewHelper.createProgressView()
    @IBOutlet weak var entryWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.show()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        // Transform sent url string to url and load the web view
        let entryUrl = NSURL(string: entryUrlString)!
        let request = NSURLRequest(URL: entryUrl)
        entryWebView.delegate = self
        entryWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        progressView.hide()
    }
}
