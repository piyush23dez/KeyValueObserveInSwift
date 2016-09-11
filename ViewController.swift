//
//  ViewController.swift
//  KeyValueObserveInSwift
//
//  Created by Sharma, Piyush on 9/11/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

enum ObservingType: Int {
    case WillSet = 0 , DidSet
}

class ViewController: UIViewController {

    let person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        person.name.addObserver(type: .DidSet) { (currentValue, oldValue) in
            print(currentValue,oldValue)
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.person.simulate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

struct Observable<T> {

    var observingInfo = [ObservingType : Array< ( (T,T) -> ()) >]()
    
    var raw: T {
        
        willSet {
            if let list = observingInfo[.WillSet] {
                for closure in list {
                    closure(newValue, self.raw)
                }
            }
        }
        
        didSet {
            
            if let list = observingInfo[.DidSet] {
                for closure in list {
                    print(self.raw)
                    closure(self.raw, oldValue)
                }
            }
        }
    }
    
    init(_ value: T) {
        self.raw = value
        
        observingInfo[.WillSet] = Array<(T,T) -> ()>()
        observingInfo[.DidSet] = Array<(T,T) -> ()>()
    }
    
    mutating func addObserver(type: ObservingType, closure: ((T,T) -> ())) {
        var allObservers: Array<(T,T) -> ()> = observingInfo[type]!
        allObservers.append(closure)
        observingInfo[type]! = allObservers
    }
    
    func __conversion() -> T {
        return raw
    }
}


class Person {
    var name = Observable("Piyush")
    
    func simulate() {
        name.raw = "Mohit"
    }
}
