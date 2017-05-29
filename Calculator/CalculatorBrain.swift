//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 郭秭含 on 2017/5/28.
//  Copyright © 2017年 郭秭含. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator: Double? // private - internal. because at the begining of calculation there's no value, accumulator = 0 doesn't make sense. Therefore, we set it as optional.
    
    private var resultIsPending = false
    
    private var desEndWithNumber = false
    
    private var description: String?
    
    private enum Operation {// a data structure has discrete values
        case constant(Double, des: String)
        case unaryOperation((Double) -> Double, des: String)
        case binaryOperation((Double, Double) -> Double, des: String)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi, des: "π"),
        "e": Operation.constant(M_E, des: "e"),
        "√": Operation.unaryOperation(sqrt, des: "√"),
        "cos": Operation.unaryOperation(cos, des: "cos"),
        "±": Operation.unaryOperation({ -$0 }, des: "±"),
        "×": Operation.binaryOperation({ $0 * $1 }, des: "×"),
        "÷": Operation.binaryOperation({ $0 / $1 }, des: "÷"),
        "+": Operation.binaryOperation({ $0 + $1 }, des: "+"),
        "-": Operation.binaryOperation({ $0 - $1 }, des: "-"),
        "x^y": Operation.binaryOperation({ pow($0, $1) }, des: "^"),
        "2^x": Operation.unaryOperation({ pow(2.0, $0) }, des: "2^"),
        "e^x": Operation.unaryOperation({ pow(M_E, $0) }, des: "e^"),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let (value, des)):
                accumulator = value
                if desEndWithNumber {
                    description = des
                } else {
                    description = "\(description ?? "")\(des)"
                }
                desEndWithNumber = true
            case .unaryOperation(let (function, des)):
                if accumulator != nil {
                    if desEndWithNumber {
                        description = "\(des)(\(description!))"
                    } else {
                        description = (description ?? "") + "\(des)(\(accumulator!))"
                    }
                    desEndWithNumber = true
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let (function, des)):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    if desEndWithNumber {
                        description = (description ?? "") + "\(des)"
                    } else {
                        description = (description ?? "") + "\(accumulator!)\(des)"
                    }
                    desEndWithNumber = false
                    resultIsPending = true
                    accumulator = nil
                }
            case .equals:
                if pendingBinaryOperation != nil && accumulator != nil && description != nil {
                    if !desEndWithNumber {
                        description = "\(description!)\(accumulator!)"
                    }
                    desEndWithNumber = true
                    accumulator = pendingBinaryOperation!.perform(with: accumulator!)
                    resultIsPending = false
                    pendingBinaryOperation = nil
                }
            }
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation? // We are not always in the middle of pending binary operation
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        mutating func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if !resultIsPending {
            description = nil
            desEndWithNumber = false
        }
    }
    
    var currentDescription: String? {
        get {
            if let des = description {
                if resultIsPending {
                    return des + "..."
                } else {
                    return des + "="
                }
            } else {
                return nil
            }
        }
        set {
            description = nil
            desEndWithNumber = false
        }
    }
    
    var result: Double? { // result (for outside) is a read-only property
        get {
            return accumulator
        }
        set {
            accumulator = nil
        }
    }
}
