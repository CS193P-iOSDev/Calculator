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
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if userIsInTheMiddleOfTyping {
                let textCurrectlyInDisplay = display.text!
                if digit == "." && textCurrectlyInDisplay.characters.index(of: ".") != nil {
                    return
                }
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
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle, mathematicalSymbol == "C" {
            userIsInTheMiddleOfTyping = false
            brain.result = nil
            brain.currentDescription = nil
            updateDisplay()
            return
        }
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
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

