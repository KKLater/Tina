//
//  ViewController.swift
//  Tina-SPM-Demo-macos
//
//  Created by 罗树新 on 2020/12/14.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let b = Bin()
        b.startTest()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

