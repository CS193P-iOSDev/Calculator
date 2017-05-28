//
//  ViewController.swift
//  Calculator
//
//  Created by 郭秭含 on 2017/5/28.
//  Copyright © 2017年 郭秭含. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsInTheMiddleOfTyping {
                let textCurrectlyInDisplay = display.text!
                display.text = textCurrectlyInDisplay + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTyping = true
            }
        }
    }
    
    var displayValue: Double { // track contents in display.
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "π":
                displayValue = Double.pi
            case "√":
                displayValue = sqrt(displayValue)
            default:
                break
            }
        }
    }
}

