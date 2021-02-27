//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by prashant thakare on 26/02/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
   let table:UITableView = UITableView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Person]?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        table.dataSource = self
        table.delegate = self
        table.register(NewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        let rightBtn = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAddBtn))
        
        self.navigationItem.rightBarButtonItem = rightBtn
        navigationItem.title = "welcome"
        
        self.view.addSubview(table)
        
        fetchPeople()
        
        
        
    }
    @objc func didTapAddBtn(){
    
        let alertC = UIAlertController(title: "Add Task", message: "New Task", preferredStyle: .alert)
       
        alertC.addTextField(configurationHandler: nil)
        
       
        
        let submitBtn = UIAlertAction(title: "add", style: .default) { (action) in
            
            let textField = alertC.textFields![0]
            if alertC.textFields![0].text == ""{
            
                let alertC = UIAlertController(title: "please write something", message: "", preferredStyle: .alert)
                alertC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alertC, animated: true, completion: nil)
                
                
            }
            else{
                let newPerson = Person(context:self.context)
                
                newPerson.name = textField.text
                newPerson.age = 20
                newPerson.gender = "male"
                
                
                do {
                    
                    try self.context.save()
                }
                catch{
                    
                    
                }
                self.fetchPeople()
            }
            
            
            
            
            
            
        }
        alertC.addAction(submitBtn)
        self.present(alertC,animated: true)
        
        
        
        
        
    }
    
    
    
    
    
    func fetchPeople(){
        do{
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        catch{
            
            
        }
       
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        table.frame = CGRect(x: 0 , y: 20, width: view.frame.size.width, height: view.frame.size.height)
//
        
    }
    
    
  


}

//MARK:- tableView

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! NewTableViewCell
        let person = self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "delete") { (action, view, completion) in
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            // Remove the person
            self.context.delete(personToRemove)
            
            //save the data
            do{
                try self.context.save()
                
            }
            catch{
                
            }
            // to do:- Re-fetch the data
            self.fetchPeople()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // selected data
        let person = self.items![indexPath.row]
        
        let alertC = UIAlertController(title: "Edit Your Task", message: "Add", preferredStyle: .alert)
        
        alertC.addTextField(configurationHandler: nil)
        let textF = alertC.textFields![0]
        textF.text = person.name
        
        let saveBtn = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            
            
            let textF = alertC.textFields![0]
            
            person.name = textF.text
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            self.fetchPeople()
        }
        
        alertC.addAction(saveBtn)
        self.present(alertC, animated: true, completion: nil)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return CGFloat(60)
    }
    
    
    
    
    
    
}

