//
//  ViewController.swift
//  ToDoList
//
//  Created by LUIS GONZALEZ on 14/10/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var toDoListTable: UITableView!
    
    var toDoListTask = [Tarea]()
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        var taskName = UITextField()
        
        let alert = UIAlertController(title: "Nueva", message: "Tarea", preferredStyle: .alert)
        
        let actionAccept = UIAlertAction(title: "Agregar", style: .default) {_ in
            let newTask = Tarea(context: self.contexto)
            newTask.name = taskName.text
            newTask.realized = false
            self.toDoListTask.append(newTask)
            
            self.saveTask()
        }
        alert.addTextField{ textFieldAlert in
            textFieldAlert.placeholder = "Escribe tu nota aqui"
            taskName = textFieldAlert
            }
        
        alert.addAction(actionAccept)
        present(alert, animated: true)
    }
    
    func saveTask(){
        do {
            try contexto.save()
        } catch  {
            print(error.localizedDescription)
        }
        
        self.toDoListTable.reloadData()
        
    }
    

}

extension ViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTable.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let tarea = toDoListTask[indexPath.row]
        // ternario
        cell.textLabel?.text = tarea.name
        cell.textLabel?.textColor = tarea.realized ? .black : .blue
        cell.detailTextLabel?.text = tarea.realized ? "Completada" : "Por completar"
        // marcar con paloma las tareas completadas
        cell.accessoryType = tarea.realized ? .checkmark : .none
        
        return cell
    }
    
    
    
}
