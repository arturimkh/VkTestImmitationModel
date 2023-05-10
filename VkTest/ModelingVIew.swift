//
//  ModelingVIew.swift
//  VkTest
//
//  Created by Artur Imanbaev on 06.05.2023.
//

import UIKit

class ModelingVIew: UIView {
    
    var amountOfSick: Int?
    var frequency: Double?
    var people: [PersonView] = []
    init(frame: CGRect, amountOfSick: Int, frequency: Double){
        self.amountOfSick = amountOfSick
        self.frequency = frequency
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    }
    func startGame(){
        
    }
    
}
