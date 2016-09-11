//
//  ViewController.swift
//  KeyValueObserveInSwift
//
//  Created by Sharma, Piyush on 9/11/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var employee = Employee()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employee.salary?.addObserver(type: .DidSet, closure: { (oldValue, newValue) in
            print("oldValue: \(oldValue) and new value is: \(newValue)")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [unowned self] timer in
            self.employee.updateSalary(salary: 100)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

enum ObservingType: Int {
    case WillSet = 0, DidSet
}

struct Observable<T> {
    
    //Dictionary to hold array of observing properties with their observing type
    private var observersDict = [ObservingType : Array<(T,T) -> ()>]()
  
    var value: T {
        
        willSet {
            
            if let list = observersDict[.WillSet] {
                for closure in list {
                    closure(newValue, self.value)
                }
            }
        }
        
        didSet {
            if let list = observersDict[.DidSet] {
                for closure in list {
                    closure(self.value, self.value)
                }
            }
        }
    }
    
    //Implicit conversion between types
    fileprivate func __conversion() -> T {
        return value
    }
    
    //Initialize dictionary with default values for both observing types
    init(_ value: T) {
        self.value = value
        observersDict[.WillSet] = Array<(T,T) -> ()>()
        observersDict[.DidSet] = Array<(T,T) -> ()>()
    }
    
    //Observing class add observer using this method using callback closure
    mutating func addObserver(type: ObservingType, closure: ((T,T) -> ())) {
        var currentObservers = observersDict[type]
        currentObservers?.append(closure)
        observersDict[type] = currentObservers
    }
}


class Employee {
    var salary: Observable<Int>?
    
    init() {
        self.salary = Observable(50)
    }
    
    func updateSalary(salary: Int) {
        self.salary?.value = salary
    }
}
