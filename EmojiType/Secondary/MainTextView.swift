//
//  MainTextField.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/18/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
  
  //Text change, seeing if correct, adding colors to right/wrong, update epm and accuracy, test if completed
  func textViewDidChange(_ textView: UITextView) {
    guard let currentTyped = textView.text?.toArray() else { return }
    guard let last = textView.text.last else { return }
    position+=1
    if(position == 1) { setupEmojis() }
    if(currentTyped.count >= emojis.count) { complete(); return }
    let attributedString = NSMutableAttributedString(string: "", attributes: [.backgroundColor: UIColor.clear])
    if(emojis[currentTyped.count - 1] == String(describing: last)) {
      correct+=1
    } else {
      incorrect+=1
      generator.notificationOccurred(.error)
    }
    for i in 0..<currentTyped.count {
      if(emojis[i] == currentTyped[i]) {
        attributedString.append(NSAttributedString(string: emojis[i], attributes: [.backgroundColor: UIColor.rgb(red: 34, green: 181, blue: 98).withAlphaComponent(0.5), .font: UIFont.customFont(size: 40)]))
      } else {
        attributedString.append(NSAttributedString(string: emojis[i], attributes: [.backgroundColor: UIColor.rgb(red: 242, green: 107, blue: 90).withAlphaComponent(0.5), .font: UIFont.customFont(size: 40)]))
      }
    }
    for j in currentTyped.count..<emojis.count {
      attributedString.append(NSAttributedString(string: emojis[j], attributes: [.backgroundColor: UIColor.clear, .font: UIFont.customFont(size: 40)]))
    }
    emojiTextView.attributedText = attributedString
    scrollTextView(text: textView.text)
    changeStats()
  }
  
  //Prevent backspace
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text.isEmpty {
      return false
    }
    return true
  }
  
  //Start the timer
  func setupEmojis() {
    self.countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTimer), userInfo: nil, repeats: true)
    RunLoop.current.add(countTimer, forMode: .common)
    startLabel.alpha = 0
  }
  
  //Scrolls text up based on row
  func scrollTextView(text: String) {
    let emojiTextViewWidth = emojiTextView.frame.size.width
    let emojisInEachRow = Int(emojiTextViewWidth/40)
    if(text.count%Int(Double(emojisInEachRow)*1.3) == 0) {
      emojiTextView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
      scrollOffset+=50
    }
  }
  
  //Update epm and accuracy in progress bar and notification bar
  func changeStats() {
    let accuracy = Float(correct/(correct + incorrect))
    accuracyBar.setProgress(accuracy, animated: true)
    if(accuracy >= 0.70) { accuracyBar.progressTintColor = UIColor.rgb(red: 34, green: 181, blue: 98) }
    if(accuracy < 0.70 && accuracy > 0.30) { accuracyBar.progressTintColor  = UIColor.rgb(red: 255, green: 241, blue: 117) }
    if(accuracy <= 0.30) { accuracyBar.progressTintColor  = UIColor.rgb(red: 242, green: 107, blue: 90) }
  }
  
  //End everything and update overall stats in user defaults
  func complete() {
    let defaults = UserDefaults.standard
    let accuracy = Float(correct/(correct + incorrect)) * 100
    let epm = Int(correct)
    
    let oldAccuracy = defaults.double(forKey: "accuracy")
    let oldEPM = defaults.integer(forKey: "epm")
    
    let roundedAccuracy = Double((accuracy/10).rounded()*10)
    
    if(oldAccuracy == -1.0 && oldEPM == -1) {
      defaults.set(roundedAccuracy, forKey: "accuracy")
      defaults.set(epm, forKey: "epm")
    } else {
      defaults.set((roundedAccuracy+oldAccuracy)/2, forKey: "accuracy")
      defaults.set(Int((epm+oldEPM)/2), forKey: "epm")
    }
    countTimer.invalidate()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//      let startVC = StartViewController()
//      startVC.modalPresentationStyle = .fullScreen
//      self.present(startVC, animated: true, completion: nil)
//    }
  }
  
  //Update timer and update EPM and detect when timer reachers 0
  @objc func changeTimer() {
    time-=1
    var epm = 0.0
    if(time != 60) {
      epm = (60*correct)/Double(60-time)
    }
    let epmView = EPMView()
    epmView.epmValue.text = String(describing: Int(epm))
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: epmView)
    if(time <= 0) {
      navigationController?.navigationBar.topItem?.title = "0"
      complete()
    } else if(time > 0) {
      navigationController?.navigationBar.topItem?.title = String(describing: time)
    }
  }
}
