//
//  EmojiTypeApp.swift
//  EmojiType
//
//  Created by Other on 4/6/24.
//  Copyright © 2024 Nicholas Egnatz. All rights reserved.
//

import UIKit
import SwiftUI

@main
struct EmojiTypeApp: App {
  var body: some Scene {
    WindowGroup {
      StartView()
        .ignoresSafeArea()
    }
  }
}

struct StartView: UIViewControllerRepresentable {
  typealias UIViewControllerType = StartViewController
  
  func makeUIViewController(context: Context) -> StartViewController {
    let controller = StartViewController()
    return controller
  }
  
  func updateUIViewController(_ uiViewController: StartViewController, context: Context) {
    
  }
}

#Preview {
  StartView().ignoresSafeArea()
}
