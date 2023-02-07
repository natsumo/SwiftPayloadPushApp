//
//  ViewController.swift
//  SwiftPayloadPushApp
//
//  Created by ikeda.natsumo on 2023/02/07.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var payload: UITextView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController = self
        
        payload.text = appDelegate.payloadData
    }


}

