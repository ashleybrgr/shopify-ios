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

