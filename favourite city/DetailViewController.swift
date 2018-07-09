//
//  DetailViewController.swift
//  favourite city
//
//  Created by Sanya Jain on 09/07/18.
//  Copyright © 2018 Sanya Jain. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {



    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var populationtextfield: UITextField!
    
    var detailItem: City? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureView () {
        // update the user interface for the deyail item
        if let city = self.detailItem {
            if cityTextField  != nil {
                cityTextField.text = city.name
                stateTextField.text = city.state
                populationtextfield.text = String( city.population)
                imageview.image =  UIImage(data: city.image)
            }
        }
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        if let city = self.detailItem {
        city.name = cityTextField.text!
            city.state = stateTextField.text!
            city.population = Int(populationtextfield.text!)!
    }

}


}
