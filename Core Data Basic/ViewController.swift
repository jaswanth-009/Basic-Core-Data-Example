//
//  ViewController.swift
//  Core Data Basic
//
//  Created by Kunjeti Jassvanthh on 02/05/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var persons: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HitList"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            persons = try managedObjectContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add item to list", message: "Add a name", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
                return
            }
        self.save(name: nameToSave)
        self.tableView.reloadData()
        })
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        person.setValue(name, forKey: "name")
        do {
            try managedObjectContext.save()
            persons.append(person)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
        
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
              tableView.dequeueReusableCell(withIdentifier: "Cell",
                                            for: indexPath)
        let person = persons[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
    }
}
