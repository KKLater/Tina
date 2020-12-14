//
//  InterfaceController.swift
//  Tina-Demo-watchos WatchKit Extension
//
//  Created by 罗树新 on 2020/12/14.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        let b = Bin()
        b.startTest()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
