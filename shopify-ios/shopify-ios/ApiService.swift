//
//  ApiService.swift
//  
//
//  Created by Ashley Berger on 2017-04-27.
//
//

import Alamofire
import SwiftyJSON

private let ApiServiceInstance = ApiService()
class ApiService {
  class var sharedInstance: ApiService {
    return ApiServiceInstance
  }
  
  let TOKEN = "c32313df0d0ef512ca64d5b336a0d7c6"
  let alamofireManager: Alamofire.Manager?
  let url = "https://shopicruit.myshopify.com/admin/"
  let apiTimeout = JSON(["error" : ["message":"Request Timeout"]])
  
  init() {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    self.alamofireManager = Alamofire.Manager(configuration: configuration)
  }

  
  enum Router: URLRequestConvertible {
    static let url = "https://shopicruit.myshopify.com/admin/"
    static let Token: String = "c32313df0d0ef512ca64d5b336a0d7c6"
    static let Path: String = ""
    
    case Get([String: AnyObject]?)
    case Post([String: AnyObject])
    case Put([String: AnyObject])
    case Delete([String: AnyObject])
    
    var method: Alamofire.Method {
      switch self {
      case .Post:
        return .POST
      case .Get:
        return .GET
      case .Put:
        return .PUT
      case .Delete:
        return .DELETE
      }
    }
    
    var URLRequest: NSMutableURLRequest {
      let URL = NSURL(string: Router.url)!
      let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(Router.Path))
      mutableURLRequest.HTTPMethod = method.rawValue
      
      if Router.Token != "" {
        mutableURLRequest.setValue(Router.Token, forHTTPHeaderField: "Authorization")
      }
      
      switch self {
      case .Get(let parameters):
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
      case .Post(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      case .Put(let parameters):
        return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
      case .Delete(let parameters):
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
      }
    }
    
  }
  
  func get(path: String, params: [String:AnyObject]? = nil, requestCompleted: (_ responseBody: JSON) -> ()) {
    Router.Path = path
    
    alamofireManager!.request(Router.Get(params)).responseJSON { response in
      if response.result.isFailure {
        requestCompleted(responseBody: self.apiTimeout)
      }
        
      else {
        var safeResponse = response.result.value
        if safeResponse == nil {
          safeResponse = []
        }
        requestCompleted(responseBody: JSON(safeResponse!))
      }
    }
  }
}



