//
//  StartViewController.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/17/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class StartViewController: UIViewController {
    
    var timer: Timer?
    var timer2: Timer?
    
    let header: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customBoldFont(size: 40)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    let cursor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.textColor()
        return view
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.appColor()
        button.isEnabled = false
        return button
    }()
    
    let epmLabel: UILabel = {
        let label = UILabel()
        label.text = "EPM"
        label.font = UIFont.customBoldFont(size: 25)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    let epmValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(size: 20)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    let accuracyLabel: UILabel = {
        let label = UILabel()
        label.text = "Accuracy"
        label.font = UIFont.customBoldFont(size: 25)
        label.textColor = UIColor.textColor()
        return label
    }()
    
    let accuracyValue: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.customFont(size: 20)
        label.textColor = UIColor.textColor()
        return label
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        getStats()
        animateHeader()
        setupStartTap()
    }
    
    func setupStartTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func create() {
        view.backgroundColor = UIColor.backgroundColor()
        view.isUserInteractionEnabled = true
        
        let titleView = UIView()
        view.addSubview(titleView)
        titleView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        header.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        header.addSubview(cursor)
        cursor.anchor(top: header.topAnchor, left: nil, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 3, paddingLeft: 0, paddingBottom: -3, paddingRight: -7, width: 2, height: 0)
        cursor.layer.cornerRadius = 1
        
        view.addSubview(startButton)
        startButton.constrainSize(width: 300, height: 65)
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startButton.layer.cornerRadius = 65/2
        
        let statsView = UIView()
        view.addSubview(statsView)
        statsView.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let epmStack = UIStackView(arrangedSubviews: [epmLabel, epmValue])
        epmStack.axis = .vertical
        epmStack.alignment = .center
        epmStack.spacing = 5
        view.addSubview(epmStack)
        epmStack.anchor(top: nil, left: startButton.leftAnchor, bottom: nil, right: startButton.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        epmStack.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        
        let accuracyStack = UIStackView(arrangedSubviews: [accuracyLabel, accuracyValue])
        accuracyStack.axis = .vertical
        accuracyStack.alignment = .center
        accuracyStack.spacing = 5
        view.addSubview(accuracyStack)
        accuracyStack.anchor(top: nil, left: startButton.centerXAnchor, bottom: nil, right: startButton.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        accuracyStack.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
    }
    
    func getStats() {
        let defaults = UserDefaults.standard
        let epm = defaults.integer(forKey: "epm")
        let accuracy = defaults.double(forKey: "accuracy")
        //Check if first load
        if(accuracy == -1.0 && epm == -1) {
            epmValue.text = "0"
            accuracyValue.text = "0%"
        } else {
            epmValue.text = String(describing: epm)
            accuracyValue.text = String(describing: Int(accuracy)) + "%"
        }
        if(accuracy >= 70.0) { accuracyValue.textColor = UIColor.rgb(red: 34, green: 181, blue: 98) }
        if(accuracy < 70.0 && accuracy > 30.0) { accuracyValue.textColor = UIColor.rgb(red: 255, green: 241, blue: 117) }
        if(accuracy <= 30.0) { accuracyValue.textColor = UIColor.rgb(red: 242, green: 107, blue: 90) }
    }
    
    func animateHeader() {
        let str = "Emoji Type 😄".toArray()
        var i = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            if(i == str.count - 1) {
                self.cursor.alpha = 0
                self.header.text?.append(str[i])
                i+=1
            }
            if(i >= str.count) {
                self.timer?.invalidate()
                self.animateEmojis()
            } else {
                self.header.text?.append(str[i])
                i+=1
            }
        }
    }
    
    func animateEmojis() {
        var emojiOptions = ["😄","🔥","🥵","👻","🤡","😇","☀️","⚽️","🍎","😅","🤖","🤘","🥶","🐤","🌍","🍔","🚗","🚀","💈","🔑","🥳"]
        emojiOptions.shuffle()
        var i = 0
        var counter = 0
        timer2 = Timer.scheduledTimer(withTimeInterval: 1.25, repeats: true) { (timer) in
            if(i >= emojiOptions.count) { i = 0 }
            if(counter >= 100) {
                self.timer2?.invalidate()
            } else {
                self.header.text?.removeLast()
                self.header.text?.append(emojiOptions[i])
            }
            i+=1
            counter+=1
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.setNeedsUpdateConstraints()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        timer?.invalidate()
        timer2?.invalidate()
        let mainVC = UINavigationController(rootViewController: MainViewController())
        self.present(mainVC, animated: true, completion: nil)
    }
}
