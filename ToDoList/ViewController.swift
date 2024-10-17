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
    
    //REFERENCIA AL CONTENER DE CORE DATA
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTable.dataSource = self
        toDoListTable.delegate = self
        readTasks()
    }

    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        var taskName = UITextField()
        
        let alert = UIAlertController(title: "Nueva", message: "Tarea", preferredStyle: .alert)
        
        let actionAccept = UIAlertAction(title: "Agregar", style: .default) { (_) in
            let newTask = Tarea(context: self.contexto)
            newTask.nombre = taskName.text
            newTask.realizada = false
            self.toDoListTask.append(newTask)

            self.saveTask()

            
        }
        alert.addTextField{ textFieldAlert in
            textFieldAlert.placeholder = "Escribe tu tarea aqui ..."
            taskName = textFieldAlert
            }
        
        alert.addAction(actionAccept)
        present(alert, animated: true)
    }
    
    func saveTask(){
        do {
            try contexto.save()
        }   catch  {
            print(error.localizedDescription)
        }
        self.toDoListTable.reloadData()
    }
    
    func readTasks() {
        let solicitud : NSFetchRequest<Tarea> = Tarea.fetchRequest()
        do {
            toDoListTask =  try contexto.fetch(solicitud)
        } catch {
            print(error.localizedDescription)
        }
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
        cell.textLabel?.text = tarea.nombre
        cell.textLabel?.textColor = tarea.realizada ? .black : .blue
        cell.detailTextLabel?.text = tarea.realizada ? "Completada" : "Por completar"
        // marcar con paloma las tareas completadas
        cell.accessoryType = tarea.realizada ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // palomear tarea                //indexpath indica la celda que el usuario selecciona
        if toDoListTable.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            toDoListTable.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            toDoListTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // editar core data
        toDoListTask[indexPath.row].realizada = !toDoListTask[indexPath.row].realizada
        saveTask()
        
        //des seleccionar la tarea
        toDoListTable.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

