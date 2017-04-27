//
//  ViewController.swift
//  shopify-ios
//
//  Created by Ashley Berger on 2017-04-26.
//  Copyright © 2017 Ashley Berger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var topSpacer: UIView!
  @IBOutlet weak var bottomSpacer: UIView!
  
  
  let TOKEN = "c32313df0d0ef512ca64d5b336a0d7c6"
  let url = "https://shopicruit.myshopify.com/admin/"
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    stylize()
    
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

