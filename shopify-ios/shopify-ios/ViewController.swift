//
//  ViewController.swift
//  shopify-ios
//
//  Created by Ashley Berger on 2017-04-26.
//  Copyright © 2017 Ashley Berger. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var topSpacer: UIView!
  @IBOutlet weak var bottomSpacer: UIView!
  @IBOutlet weak var totalRevenueLabel: UILabel!
  @IBOutlet weak var keyboardLabel: UILabel!
  
  let URL = "https://shopicruit.myshopify.com/admin/"
  let TOKEN = "c32313df0d0ef512ca64d5b336a0d7c6"
  let KEYBOARD_NAME = "Aerodynamic Cotton Keyboard"
  
  var totalKeyboards: Int = 0
  
  override func viewWillAppear(_ animated: Bool) {
    
    makeCircular(views: [topView, bottomSpacer, topSpacer])
    
    getOrders { (response) in
      
      let errors = response["errors"]
      guard (!errors.exists()) else {
        print(errors)
        return
      }
      
      self.parseOrders(response: response)
    }
  }
  
  func parseOrders(response: JSON) {
    guard let orders = response["orders"].array else { return }
    
    let revenue: Double = orders.reduce(0, {
      
      guard let products = $1["line_items"].array else { return $0 }
      
      self.totalKeyboards += products.reduce(0, {
        guard let title = $1["title"].string else { return $0 }
        guard let quantity = $1["quantity"].int else { return $0 }
        let contains = title == self.KEYBOARD_NAME
        return $0 + (contains ? quantity : 0)
      })
      
      if let price = $1["total_price"].string, let doublePrice = Double(price) {
        return $0 + doublePrice
      }
      return $0
    })
    self.totalRevenueLabel.text = "$" + String(revenue)
    self.keyboardLabel.text = String(self.totalKeyboards)
  }


  func getOrders(_ cb: @escaping (_ response: JSON) -> ()){
    Alamofire.request(URL+"orders.json", method: .get, parameters: ["page":"1", "access_token":TOKEN], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in

      switch(response.result) {
      case .success(let data):
        cb(JSON(data))
        break
        
      case .failure(_):
        cb(JSON(["errors": ["message":"Timeout."]]))
        break
        
      }
    }
  }
  
  func makeCircular(views: [UIView]) {
    for view in views {
      view.layer.cornerRadius = view.frame.width / 2
      view.clipsToBounds = true
    }
  }
  
}

