//
//  ViewController.swift
//  Calculator
//
//  Created by 郭秭含 on 2017/5/28.
//  Copyright © 2017年 郭秭含. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentSequence: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var userIsTypingFloat = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsInTheMiddleOfTyping {
                if userIsTypingFloat == false || (userIsTypingFloat == true && digit != ".") {
                    let textCurrectlyInDisplay = display.text!
                    display.text = textCurrectlyInDisplay + digit
                    if digit == "." {
                        userIsTypingFloat = true
                    }
                }
            } else {
                display.text = digit
                userIsInTheMiddleOfTyping = true
                if digit == "." {
                    userIsTypingFloat = true
                }
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
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle, mathematicalSymbol == "C" {
            userIsInTheMiddleOfTyping = false
            userIsTypingFloat = false
            brain.result = nil
            brain.currentDescription = nil
            updateDisplay()
            return
        }
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            userIsTypingFloat = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol) // to do calculation is not my job as a controller
        }
        updateDisplay()
    }
    
    func updateDisplay() {
        if let result = brain.result {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 6
            display.text = formatter.string(from: result as NSNumber)
        } 
        if let sequence = brain.currentDescription {
            currentSequence.text = sequence
        } else {
            currentSequence.text = "0"
        }
    }
}

