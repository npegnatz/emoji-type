//
//  MainViewController.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/17/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UITextViewDelegate {
    
    var emojis = [String]()
    var emojiString = ""
    var countTimer: Timer!
    var time = 60
    var correct = 0.0
    var incorrect = 0.0
    var scrollOffset = 50
    var position = 0
    
    let generator = UINotificationFeedbackGenerator()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return view
    }()
    
    let emojiTextView: UITextView = {
        let tv = UITextView()
        tv.tintColor = .clear
        tv.font = UIFont.customFont(size: 40)
        tv.autocorrectionType = .no
        tv.autocapitalizationType = .none
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return tv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.tintColor = UIColor.textColor()
        tv.font = UIFont.customFont(size: 40)
        tv.textColor = UIColor.clear
        tv.autocorrectionType = .no
        tv.autocapitalizationType = .none
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let accuracyBar: UIProgressView = {
        let pv = UIProgressView()
        pv.progressTintColor = UIColor.rgb(red: 34, green: 181, blue: 98)
        pv.progress = 1
        return pv
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customBoldFont(size: 40)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        create()
        getEmojis()
    }
    
    func delegate() {
        textView.delegate = self
    }
    
    func create() {
        view.backgroundColor = UIColor.backgroundColor()
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.topItem?.title = "60"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textColor(), .font: UIFont.customBoldFont(size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.backgroundColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: EPMView())
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.textColor()
        
        view.addSubview(accuracyBar)
        accuracyBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: accuracyBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: -20, paddingRight: 20, width: 0, height: 0)
        backgroundView.layer.cornerRadius = 12
        
        backgroundView.addSubview(emojiTextView)
        emojiTextView.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: -5, paddingRight: 5, width: 0, height: 0)
        
        let cover = UIView()
        emojiTextView.addSubview(cover)
        cover.anchor(top: emojiTextView.topAnchor, left: emojiTextView.leftAnchor, bottom: emojiTextView.bottomAnchor, right: emojiTextView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        cover.addSubview(textView)
        textView.anchor(top: cover.topAnchor, left: cover.leftAnchor, bottom: cover.bottomAnchor, right: cover.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func getEmojis() {
        APIService.shared.getEmojis(count: 100) { (emojis) in
            self.emojis = emojis
            var loadedEmojis = ""
            for e in emojis {
                loadedEmojis.append(e)
            }
            DispatchQueue.main.async {
                self.textView.becomeFirstResponder()
                self.emojiString = loadedEmojis
                self.emojiTextView.text = loadedEmojis
                self.textView.text = ""
            }
        }
    }
    
    @objc func goBack() {
        let startVC = StartViewController()
        self.textView.resignFirstResponder()
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.setNeedsUpdateConstraints()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
}


