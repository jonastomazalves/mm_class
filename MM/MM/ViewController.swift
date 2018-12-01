//
//  ViewController.swift
//  MM
//
//  Created by jonas.tomaz on 20/10/18.
//  Copyright © 2018 jonas.tomaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    class Team {
        var name:String
        private(set) var squad: [Player] = []
        var sponsors: [Sponsor] = []
        
        init(name:String) {
            self.name = name
            print("Team \(name) initialized")
        }
        
        deinit {
            print("Team \(name) deallocated")
        }
        
        func addPlayer(player:Player) {
            self.squad.append(player)
            player.club = self
        }
    }
    
    class Player {
        var name:String
        weak var club: Team?
        
        init(name:String) {
            self.name = name
            print("Player \(name) initialized")
        }
        
        deinit {
            print("Player \(name) deallocated")
        }
    }
    
    class Sponsor {
        var name:String
        var value: String
        unowned var club: Team
        
        init(name:String,value:String,club:Team ) {
            self.name = name
            self.value = value
            self.club = club

            print("Sponsor \(name) initialized")
            
            club.sponsors.append(self)
        }
        
        deinit {
            print("Sponsor \(name) deallocated")
        }
        
        lazy var fullContract: () -> String = { [weak self] in
            guard let self = self else {
                return "Contract invalid"
            }
            
            return "Name: \(self.name) , value: \(self.value) with team :\(self.club)"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var batata: () -> String
        
        do {
            var petequeiros = Team(name: "Petequeiros")
            var sara  = Player(name: "Sara")
            var mercadinho = Sponsor(name: "BigBom", value: "200", club: petequeiros)
            
            petequeiros.addPlayer(player: sara)
            
            batata = mercadinho.fullContract
            
            
        }
        
        print(batata())
//        var x = 40
//        var y = 50
//
//        var batata: () -> String = { [oldX = x, oldY = y] in
//            return "X = \(oldX) e Y = \(oldY)"
//        }
//
//        x = 60
//        y = 80
//
//        print(batata())
    }
}

