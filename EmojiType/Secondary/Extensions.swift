//
//  Extensions.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/17/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension UIView {
  
  func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
      self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
    }
    
    if let right = right {
      self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
      self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
  func constrainSize(width: CGFloat, height: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    if width != 0 {
      self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if height != 0 {
      self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
}

extension UIColor {
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  
  static func appColor() -> UIColor {
    return rgb(red: 57, green: 230, blue: 152)
  }
  
  static func backgroundColor() -> UIColor {
    return rgb(red: 31, green: 31, blue: 31)
  }
  
  static func textColor() -> UIColor {
    return rgb(red: 255, green: 255, blue: 255)
  }
  
  static func softBlack() -> UIColor {
    return rgb(red: 58, green: 58, blue: 58)
  }
  
  static func softWhite() -> UIColor {
    return rgb(red: 247, green: 247, blue: 247)
  }
}

extension UIFont {
  
  static func customFont(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
  }
  
  static func customBoldFont(size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
  }
}

extension UIViewController {
  
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension String {
  
  func toEmoji() -> String {
    let data = self.data(using: .utf8)!
    return String(data: data, encoding: .nonLossyASCII) ?? self
  }
  
  func toString() -> String {
    let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
    return String(data: data, encoding: .utf8)!
  }
  
  func toArray() -> [String] {
    var arr = [String]()
    for char in self {
      var s = ""
      s.append(char)
      arr.append(s)
    }
    return arr
  }
}

extension Array where Element == String {
  func toString() -> String {
    var str = ""
    for item in self {
      str.append(contentsOf: item)
    }
    return str
  }
}

//Found this function online to check if there is a network connection for fallback emojis
class Network {
  func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
  }
}
