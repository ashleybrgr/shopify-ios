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
  
  
  override func viewWillAppear(_ animated: Bool) {
    
    makeCircular(views: [topView, bottomSpacer, topSpacer])
    
    getOrders { (response) in
      
      let errors = response["errors"]
      guard (!errors.exists()) else {
        print(errors)
        return
      }
      
      let count = self.parseOrders(response: response)
      self.totalRevenueLabel.text = "$" + String(format: "%.2f", count.0)
      self.keyboardLabel.text = String(count.1)
      
    }
  }
  
  func parseOrders(response: JSON) -> (Double, Int) {
    guard let orders = response["orders"].array else { return (0.00, 0) }
    
    return orders.reduce((0,0), { (result: (Double, Int), order) in
      
      var keyboards = 0, price = 0.00;
      if let foundKeyboard = order["line_items"].arrayValue.first(where: {$0["title"].stringValue == KEYBOARD_NAME}) {
        keyboards += foundKeyboard["quantity"].intValue
      }
      if let total = order["total_price"].string, let doublePrice = Double(total) {
        price += doublePrice
      }

      return(result.0 + price, result.1 + keyboards)
    })
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


