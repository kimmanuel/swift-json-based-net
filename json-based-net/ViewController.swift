//
//  ViewController.swift
//  json-based-net
//
//  Created by Kim Manuel on 01/08/2016.
//  Copyright © 2016 Kim Manuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let net: JSONNet = JSONNet()
        
        net.get("http://jsonplaceholder.typicode.com/posts", withParameters: nil, startBlock: { (net) in
            
            }, finishBlock: { (net, responseObject) in
                print(responseObject.array)
            }, failBlock: { (net, error) in
                
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

