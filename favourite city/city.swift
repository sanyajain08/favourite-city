//
//  city.swift
//  favourite city
//
//  Created by Sanya Jain on 09/07/18.
//  Copyright © 2018 Sanya Jain. All rights reserved.
//

import UIKit

class city: Codable {
    
    var name : String
    var state : String
    var population : Int
    var image : Data
    
    init(name: String, state: String, population : Int, image: Data) {
        self.name = name
        self.state = state
        self.population = population
        self.image = image
    }
    

}
