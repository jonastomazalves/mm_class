//: Playground - noun: a place where people can play

import UIKit

class Team {
    var name:String
    
    init(name:String) {
        self.name = name
        print("Team \(name) initialided")
    }
    
    deinit {
        print("Team \(name) deinitialized")
    }
}

class Player {
    var name:String
    
    init(name:String) {
        self.name = name
        print("Player \(name) initialided")
    }
    
    deinit {
        print("Player \(name) deinitialized")
    }
}

class Sponsor {
    var name:String
    var value:String
    var duration:String

    init(name:String,value:String,duration:String) {
        self.name = name
        self.value = value
        self.duration = duration
        
        print("Sponsor \(name) initialided")
    }
    
    deinit {
        print("Sponsor \(name) deinitialized")
    }
}


