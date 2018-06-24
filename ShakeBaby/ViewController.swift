//
//  ViewController.swift
//  ShakeBaby
//
//  Created by Rajani Kaparthy on 2018-04-04.
//  Copyright © 2018 Rajani Kaparthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var todoTable: UITableView!
    var todo = [String]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardDidHide, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        getListAndLoad()
        todoTable.isEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tableviewbottomdist: NSLayoutConstraint!
    @objc func keyBoardWillShow(notification: NSNotification) {
        //handle appearing of keyboard here
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableviewbottomdist.constant = -keyboardHeight
            view.layoutIfNeeded()
            
        }
        
        
        
    }
    
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
        tableviewbottomdist.constant = 0
        view.layoutIfNeeded()
    }
    
    
    func getListAndLoad()
    {
        
        if let savedList = defaults.array(forKey : "todolist") as? [String]
        {
            todo = savedList
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo")!
        cell.textLabel?.text = todo[indexPath.row]//"hej\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(todo.count == 0)
        {
            return
        }
        todo.remove(at: indexPath.row)
        addToListTable()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /* let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
         print("Update action ...")
         success(true)
         })
         modifyAction.image = UIImage(named: "hammer")
         modifyAction.backgroundColor = .blue
         
         return UISwipeActionsConfiguration(actions: [modifyAction])*/
        
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete action ...")
            self.todo.remove(at: indexPath.row)
            self.addToListTable()
            success(true)
        })
        
        deleteAction.backgroundColor = .red
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        
        modifyAction.backgroundColor = .blue
        /*
         return UISwipeActionsConfiguration(actions: [modifyAction])
         */
        return UISwipeActionsConfiguration(actions: [modifyAction,deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var themovedstring = todo[sourceIndexPath.row]
        todo.remove(at: sourceIndexPath.row)
        todo.insert(themovedstring, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        //  textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        addTextToList()
        
    }
    
    func addTextToList()
    {
        if(textField.text == "")
        {
            return
        }
        todo.append(textField.text!)
        addToListTable()
        let theRowToScrollTo = IndexPath(row: todo.count-1, section: 0)
        todoTable.scrollToRow(at: theRowToScrollTo, at: .bottom, animated: true)
        textField.text = ""
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTextToList()
        return true
    }
    
    func addToListTable()
    {
        defaults.set(todo, forKey: "todolist")
        defaults.synchronize()
        todoTable.reloadData()
    }
    
    
    
    
}



