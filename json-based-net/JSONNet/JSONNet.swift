//
//  JSONNet.swift
//  json-based-net
//
//  Created by Kim Manuel on 01/08/2016.
//  Copyright © 2016 Kim Manuel. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import SwiftyJSON

class JSONNet: NSObject {
    
    typealias JSONNetStart = (net: JSONNet) -> Void
    typealias JSONNetFinish = (net: JSONNet, responseObject: JSON) -> Void
    typealias JSONNetFail = (net: JSONNet, error: NSError) -> Void
    
    var shouldGetHTTPHeaders: Bool?
    let kJSONNetEnvironment: JSONNetEnvironment? = .Alpha
    let kJSONNetTimeOutInterval = 60
    let kJSONNetEnvironmentLive = "company.com"
    let kJSONNetEnvironmentBeta = "beta.company.com"
    let kJSONNetEnvironmentAlpha = "alpha.company.com"
    let kJSONNetUnableToConnectMessage = "Unable to Connect"
    let kJSONNetUnableToConnectCode = -99
    
    enum JSONNetMethod: Int {
        case Get
        case Post
        case Put
        case Delete
    }
    
    enum JSONNetEnvironment: Int {
        case Live
        case Beta
        case Alpha
    }
    
    func get(path: NSString, withParameters params: [NSObject : AnyObject]?, startBlock start: JSONNetStart, finishBlock finish: JSONNetFinish, failBlock fail: JSONNetFail) -> NSURLSessionDataTask {
        
        var task: NSURLSessionDataTask? = nil
        
        if (!self.canConnect()) {
            if let newFail:JSONNetFail = fail {
                newFail(net: self, error: NSError(domain: self.getAPIPath() as String, code: kJSONNetUnableToConnectCode, userInfo: NSDictionary(object: kJSONNetUnableToConnectMessage, forKey: NSLocalizedDescriptionKey) as [NSObject : AnyObject]))
            }
            
            return task!
        }
        
        var url: NSURL = self.urlForPath(path, withParameters: params)
        
        if let _: [NSObject: AnyObject] = params {
            
            url = NSURL(string: path as String)!
        }
        
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = NSTimeInterval(kJSONNetTimeOutInterval)
        sessionConfig.timeoutIntervalForResource = NSTimeInterval(kJSONNetTimeOutInterval)
        
        let session: NSURLSession = NSURLSession(configuration: sessionConfig)
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let newError: NSError = error {
                if let newFail:JSONNetFail = fail {
                    dispatch_async(dispatch_get_main_queue(), { 
                        newFail(net: self, error: newError)
                    })
                }
            } else {
                
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                if (httpResponse.statusCode == 200) {
                    // do something here
                }
                
                if let _: JSONNetFinish = finish {
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        
                        let json = JSON(data: data!)
                        finish(net: self, responseObject: json)
                    })
                } else {
                    fail(net: self, error: error!)
                }
                
            }
        })
        
        task?.resume()
        return task!
    }
    
    func post(path: NSString, withParameters params: [NSObject : AnyObject]?, startBlock start: JSONNetStart, finishBlock finish: JSONNetFinish, failBlock fail: JSONNetFail) -> NSURLSessionDataTask {
        
        var task: NSURLSessionDataTask? = nil
        
        if (!self.canConnect()) {
            if let newFail:JSONNetFail = fail {
                newFail(net: self, error: NSError(domain: self.getAPIPath() as String, code: kJSONNetUnableToConnectCode, userInfo: NSDictionary(object: kJSONNetUnableToConnectMessage, forKey: NSLocalizedDescriptionKey) as [NSObject : AnyObject]))
            }
            
            return task!
        }
        
        var url: NSURL = self.urlForPath(path, withParameters: params)
        
        if let _: [NSObject: AnyObject] = params {
            
            url = NSURL(string: path as String)!
        }
        
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = NSTimeInterval(kJSONNetTimeOutInterval)
        sessionConfig.timeoutIntervalForResource = NSTimeInterval(kJSONNetTimeOutInterval)
        
        let session: NSURLSession = NSURLSession(configuration: sessionConfig)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var body: NSString = ""
        
        if let newParam: [NSObject: AnyObject] = params {
            body = self.getBody(newParam, withKeys: Array(newParam.keys))
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let newError: NSError = error {
                if let newFail:JSONNetFail = fail {
                    dispatch_async(dispatch_get_main_queue(), {
                        newFail(net: self, error: newError)
                    })
                }
            } else {
                
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                if (httpResponse.statusCode == 200) {
                    // do something here
                }
                
                if let _: JSONNetFinish = finish {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let json = JSON(data: data!)
                        finish(net: self, responseObject: json)
                    })
                } else {
                    fail(net: self, error: error!)
                }
                
            }
        })
        
        return task!
    }
    
    func put(path: NSString, withParameters params: [NSObject : AnyObject]?, startBlock start: JSONNetStart, finishBlock finish: JSONNetFinish, failBlock fail: JSONNetFail) -> NSURLSessionDataTask {
        
        var task: NSURLSessionDataTask? = nil
        
        if (!self.canConnect()) {
            if let newFail:JSONNetFail = fail {
                newFail(net: self, error: NSError(domain: self.getAPIPath() as String, code: kJSONNetUnableToConnectCode, userInfo: NSDictionary(object: kJSONNetUnableToConnectMessage, forKey: NSLocalizedDescriptionKey) as [NSObject : AnyObject]))
            }
            
            return task!
        }
        
        var url: NSURL = self.urlForPath(path, withParameters: params)
        
        if let _: [NSObject: AnyObject] = params {
            
            url = NSURL(string: path as String)!
        }
        
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = NSTimeInterval(kJSONNetTimeOutInterval)
        sessionConfig.timeoutIntervalForResource = NSTimeInterval(kJSONNetTimeOutInterval)
        
        let session: NSURLSession = NSURLSession(configuration: sessionConfig)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var body: NSString = ""
        
        if let newParam: [NSObject: AnyObject] = params {
            body = self.getBody(newParam, withKeys: Array(newParam.keys))
        }
        
        urlRequest.HTTPMethod = "PUT"
        urlRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let newError: NSError = error {
                if let newFail:JSONNetFail = fail {
                    dispatch_async(dispatch_get_main_queue(), {
                        newFail(net: self, error: newError)
                    })
                }
            } else {
                
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                if (httpResponse.statusCode == 200) {
                    // do something here
                }
                
                if let _: JSONNetFinish = finish {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let json = JSON(data: data!)
                        finish(net: self, responseObject: json)
                    })
                } else {
                    fail(net: self, error: error!)
                }
                
            }
        })
        
        return task!
    }
    
    func delete(path: NSString, withParameters params: [NSObject : AnyObject]?, startBlock start: JSONNetStart, finishBlock finish: JSONNetFinish, failBlock fail: JSONNetFail) -> NSURLSessionDataTask {
        
        var task: NSURLSessionDataTask? = nil
        
        if (!self.canConnect()) {
            if let newFail:JSONNetFail = fail {
                newFail(net: self, error: NSError(domain: self.getAPIPath() as String, code: kJSONNetUnableToConnectCode, userInfo: NSDictionary(object: kJSONNetUnableToConnectMessage, forKey: NSLocalizedDescriptionKey) as [NSObject : AnyObject]))
            }
            
            return task!
        }
        
        var url: NSURL = self.urlForPath(path, withParameters: params)
        
        if let _: [NSObject: AnyObject] = params {
            
            url = NSURL(string: path as String)!
        }
        
        let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = NSTimeInterval(kJSONNetTimeOutInterval)
        sessionConfig.timeoutIntervalForResource = NSTimeInterval(kJSONNetTimeOutInterval)
        
        let session: NSURLSession = NSURLSession(configuration: sessionConfig)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var body: NSString = ""
        
        if let newParam: [NSObject: AnyObject] = params {
            body = self.getBody(newParam, withKeys: Array(newParam.keys))
        }
        
        urlRequest.HTTPMethod = "DELETE"
        urlRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let newError: NSError = error {
                if let newFail:JSONNetFail = fail {
                    dispatch_async(dispatch_get_main_queue(), {
                        newFail(net: self, error: newError)
                    })
                }
            } else {
                
                let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
                
                if (httpResponse.statusCode == 200) {
                    // do something here
                }
                
                if let _: JSONNetFinish = finish {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let json = JSON(data: data!)
                        finish(net: self, responseObject: json)
                    })
                } else {
                    fail(net: self, error: error!)
                }
                
            }
        })
        
        return task!
    }
    
    func getAPIPath() -> NSString {
        
        var APIBaseURL = kJSONNetEnvironmentLive
        
        if (kJSONNetEnvironment == .Beta) {
            APIBaseURL = kJSONNetEnvironmentBeta
        } else if (kJSONNetEnvironment == .Alpha) {
            APIBaseURL = kJSONNetEnvironmentAlpha
        }
        return APIBaseURL
    }
    
    func canConnect() -> Bool {
        
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            return reachability.isReachable()
        } catch _ as NSError {
            
        } catch {
        
        }
        
        return false
    }
    
    func canConnectToWIFI() -> Bool {
        
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            return reachability.isReachableViaWiFi()
        } catch _ as NSError {
        
        } catch {
        
        }
        
        return false
    }
    
    func urlForPath(path: NSString, withParameters params: NSDictionary?) -> NSURL {
        
        let url: NSURL = NSURL.init(fileURLWithPath: path as String)
        var mQueryItems: [NSURLQueryItem] = [NSURLQueryItem]()
        
        if let newParams: NSDictionary = params {
            
            for (_, key) in newParams.enumerate() {
                
                if let newKey: AnyObject = key as? AnyObject {
                    
                    let queryItem: NSURLQueryItem = NSURLQueryItem(name: newKey as! String, value: newParams[newKey as! String] as? String)
                    mQueryItems.append(queryItem)
                }
            }
        }
        
        let components: NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!
        components.queryItems = NSArray(array: mQueryItems, copyItems: true) as? [NSURLQueryItem]
        
        return components.URL!
    }
    
    func encodeParameter(string: NSString) -> NSString {
        
        let charSet: NSCharacterSet = NSCharacterSet(charactersInString: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
        let newString: NSString = string.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
        
        if (newString != "") {
            return newString
        }
        
        return ""
    }
    
    func getBody(dict: NSDictionary, withKeys keys: NSArray) -> NSString {
        
        let sb: NSMutableString = NSMutableString(string: "")
        for (_, key) in keys.enumerate() {
            var val: AnyObject = dict[key as! NSString]!
            if (val.isKindOfClass(NSArray)) {
                var count: NSInteger = 0
                    
                for (_, _val) in (val as? NSArray)!.enumerate() {
                    sb.appendFormat("\(key)[\(count)]=\(_val)&")
                    count += 1
                }
                
            } else if (val.isKindOfClass(NSMutableArray)) {
                var count: NSInteger = 0
                
                for (_, _val) in (val as? NSMutableArray)!.enumerate() {
                    sb.appendFormat("\(key)[\(count)]=\(_val)&")
                    count += 1
                }
                
            } else {
                
                if let newVal: AnyObject = val {
                    val = newVal
                } else {
                    val = ""
                }
                
                val = self.encodeParameter(val as! NSString)
                sb.appendFormat("\(key)=\(val)&")
            }
        }
        
        return sb as NSString;
    }
    
    func getBody(dict: NSDictionary, withKeys keys: NSArray, andEncode encode: Bool) -> NSString {
    
        let sb: NSMutableString = NSMutableString(string: "")
        
        for (_, key) in keys.enumerate() {
            
            if (key.isKindOfClass(NSString)) {
                let val: AnyObject = dict[key as! NSString]!
                if (val.isKindOfClass(NSArray)) {
                    let count: NSInteger = 0
                    for (_, _val) in (val as? NSArray)!.enumerate() {
                        sb.appendFormat("\(key)[\(count)]=\(_val)&")
                        
                    }
                }
            }
        }
        
        return sb as NSString
    }
    
    
    
}