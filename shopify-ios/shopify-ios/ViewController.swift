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
  
  let URL = "https://shopicruit.myshopify.com/admin/"
  let TOKEN = "c32313df0d0ef512ca64d5b336a0d7c6"
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    stylize()
    getOrders { (response) in
      guard (!response["errors"].exists()) else {
        print(response["errors"])
        return
      }
      
      
      
    }
    
    
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
  
  func stylize() {
    topView.layer.cornerRadius = topView.frame.width / 2
    topView.clipsToBounds = true
    topSpacer.layer.cornerRadius = topSpacer.frame.width / 2
    topSpacer.clipsToBounds = true
    bottomSpacer.layer.cornerRadius = topSpacer.frame.width / 2
    bottomSpacer.clipsToBounds = true
  }
  
  
}

