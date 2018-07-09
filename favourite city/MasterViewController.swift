//
//  MasterViewController.swift
//  favourite city
//
//  Created by Sanya Jain on 09/07/18.
//  Copyright © 2018 Sanya Jain. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var cities = [City]()
    let defaults = UserDefaults.standard


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode([City].self, from: savedData) {
                cities = decoded
                
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.saveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "City"
            
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "State"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Population"
            textfield.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let insertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let cityTextField = alert.textFields![0] as UITextField
            let stateTextField = alert.textFields![1] as UITextField
            let populationtextfield = alert.textFields![2] as UITextField
            guard let image  = UIImage(named: cityTextField.text!) else {
                print ( "missing \(cityTextField.text!) image")
                return}
            if let population = Int(populationtextfield.text!){
                let city = City(name: cityTextField.text!,
                                state: stateTextField.text!,
                                population: population,
                                image: UIImagePNGRepresentation(image)! )
                    self.cities.append(city)
                    self.tableView.reloadData()
                self.saveData()
            }
            
        }
        alert.addAction(insertAction)
        present(alert, animated:  true, completion: nil)
        }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = cities[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = cities[indexPath.row]
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexaPath: IndexPath, to destinationIndexPath: IndexPath) {
        let objectToMove = cities.remove(at: sourceIndexaPath.row)
        cities.insert(objectToMove, at: destinationIndexPath.row)
        self.saveData()
    }

    func saveData() {
        if let encoded = try? JSONEncoder().encode(cities) {
            defaults.set(encoded, forKey: "data")
        }
    }
}
