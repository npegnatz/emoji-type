//
//  StartViewController.swift
//  ZapposEmoji
//
//  Created by npegnatz on 1/17/20.
//  Copyright © 2020 Nicholas Egnatz. All rights reserved.
//

import Foundation
import SwiftUI

struct StartView: View {
  //MARK: - Variables
  @State private var titleText: String = ""
  @State private var showGame: Bool = false
  @State private var timer: Timer?
  @State private var timer2: Timer?
  @State private var isCursorBlinking = false
  @State private var isCursorVisible = true
  
  //MARK: - Views
  var body: some View {
    NavigationStack {
      ZStack {
        Color(uiColor: UIColor.backgroundColor())
          .ignoresSafeArea()
        
        VStack(spacing: 100) {
          Spacer()
          Text(titleText)
            .font(.system(size: 40, weight: .medium))
            .foregroundStyle(.white)
            .overlay {
              GeometryReader { geometry in
                HStack {
                  Spacer()
                  Rectangle()
                    .fill(Color.gray)
                    .frame(width: 4)
                    .opacity(isCursorBlinking ? 0 : 1)
                    .onAppear {
                      withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                        isCursorBlinking.toggle()
                      }
                    }
                }
                .padding(.trailing, -5)
                .frame(width: geometry.size.width)
              }
            }
          
          Button("Start") {
            startGame()
          }
          .bold()
          .foregroundStyle(.white)
          .padding()
          .frame(height: 50)
          .background {
            RoundedRectangle(cornerRadius: 25)
              .fill(Color.mint)
              .frame(width: 150)
          }
          
          Spacer()
        }
      }
      .sheet(isPresented: $showGame) {
        MainView().ignoresSafeArea()
      }
    }
    .onAppear {
      getStats()
      animateHeader()
    }
  }
  
  //MARK: - Functions
  func getStats() {
    let defaults = UserDefaults.standard
    let epm = defaults.integer(forKey: "epm")
    let accuracy = defaults.double(forKey: "accuracy")
    //Check if first load
    if(accuracy == -1.0 && epm == -1) {
      //epmValue.text = "0"
      //accuracyValue.text = "0%"
    } else {
      //epmValue.text = String(describing: epm)
      //accuracyValue.text = String(describing: Int(accuracy)) + "%"
    }
    //if(accuracy >= 70.0) { accuracyValue.textColor = UIColor.rgb(red: 34, green: 181, blue: 98) }
    //if(accuracy < 70.0 && accuracy > 30.0) { accuracyValue.textColor = UIColor.rgb(red: 255, green: 241, blue: 117) }
    //if(accuracy <= 30.0) { accuracyValue.textColor = UIColor.rgb(red: 242, green: 107, blue: 90) }
  }
  
  func animateHeader() {
    let str = "Emoji Type 😄".toArray()
    var i = 0
    timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
      if(i == str.count - 1) {
        //self.isCursorVisible = false
        self.titleText.append(str[i])
        i+=1
      }
      if(i >= str.count) {
        self.timer?.invalidate()
        self.animateEmojis()
      } else {
        self.titleText.append(str[i])
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
        if counter%2==0 {
          titleText.removeLast()
        } else {
          titleText.append(emojiOptions[i])
        }
      }
      i+=1
      counter+=1
    }
  }
  
  func startGame() {
    timer?.invalidate()
    timer2?.invalidate()
    showGame = true
  }
}

struct MainView: UIViewControllerRepresentable {
  typealias UIViewControllerType = UINavigationController
  
  func makeUIViewController(context: Context) -> UINavigationController {
    let controller = UINavigationController(rootViewController: MainViewController())
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    
  }
}

#Preview {
  StartView()
}
