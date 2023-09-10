//
//  DeliOrderItems.swift
//  PV-Pocket
//
//  Created by Eric T Larsen on 1/16/20.
//  Copyright © 2020 Sean Oplinger. All rights reserved.
//

import Foundation
import Combine

class DeliOrder: ObservableObject {
    //The items chosen by the user
    @Published var chosenItems : [String] = []
    
    //There MUST be a false for every string or else the brogram will no longer work
    
    //Breads
    @Published var breadArray: [String] = ["WheatBread", "RyeBread", "WheatWrap", "SpinachWrap", "Roll"]
    @Published var TFbreadArray: [Bool] = [false, false, false, false, false]
    //Meats
    @Published var meatArray: [String] = ["Ham", "Turkey", "Salami", "Bologna", "Pepperoni", "Bacon", "BreadedChicken", "SpicyChicken"]
    @Published var TFmeatArray: [Bool] = [false, false, false, false, false, false, false, false]
    //Cheeses
    @Published var cheeseArray: [String] = ["American", "Provolone", "PepperJack", "Cheddar"]
    @Published var TFcheeseArray: [Bool] = [false, false, false, false]
    //Sauces
    @Published var sauceArray: [String] = ["Mayo", "HotSauce", "BBQSauce", "Ranch", "Chipotle", "Oil", "PVSauce"]
    @Published var TFsauceArray: [Bool] = [false, false, false, false, false, false, false]
    //Veggies
    @Published var veggieArray: [String] = ["Lettuce", "Tomato", "Cucumber", "Onion"]
    @Published var TFveggieArray: [Bool] = [false, false, false, false]
}
