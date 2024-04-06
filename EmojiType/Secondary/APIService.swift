//
//  APIService.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/17/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import UIKit

class APIService {
  
  static let shared = APIService()
  
  //Fetches "count" number of emojis and returns them in a string array/if it fails, give backup emojis
  func getEmojis(count: Int, completionHandler: @escaping ([String]) -> ()) {
    let baseURL = "https://emojigenerator.herokuapp.com/emojis/api/v1?count=" + String(describing: count)
    guard let url = URL(string: baseURL) else { return }
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.waitsForConnectivity = false
    let session = URLSession(configuration: sessionConfig)
    if(Network().isInternetAvailable()) {
      session.dataTask(with: url) { (data, response, error) in
        if error != nil { return }
        do {
          guard let emojiData = data else { return }
          let parsedData = try JSONSerialization.jsonObject(with: emojiData) as? NSDictionary
          if let emojiDict = parsedData?["emojis"] as? [String] {
            completionHandler(emojiDict)
          }
        } catch let error as NSError {
          completionHandler(self.loadBackupEmojis())
          print(error)
        }
      }.resume()
    } else {
      completionHandler(loadBackupEmojis())
    }
  }
  
  //Load backup emojis, if needed
  func loadBackupEmojis() -> [String] {
    var backupEmojis = ["😀", "😘", "😤", "🥺", "😞",      "😌","😨","😄","🔥","🥵","👻","🤡","😇","☀️","⚽️","🍎","😅","🤖","🤘","🥶","🐤","🌍","🍔","🚗","🚀","💈","🔑","🥳",
                        "📷","⛎","🍉","🇦🇿","🥭","🐴","🎍","☂️","🍏","💦","💨","🌈","🍨","🏊‍♀️","🎟","🚁","🚦","🗺","🚍","🏎","🚧","😘","😱"]
    backupEmojis.shuffle()
    return backupEmojis
  }
}
