//
//  ViewController.swift
//  DevNotes
//
//  Created by Kenneth Dait on 7/20/20.
//  Copyright © 2020 kenanigans. All rights reserved.
//

import UIKit

class NoteLibrary: UITableViewController {
    
    var noteArray = [String]()
    var addButtonItem, deleteAllButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DevNotes"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "noteCell")
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        self.addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        
        self.deleteAllButtonItem = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(deleteAllButtonTapped(_:)))
        
        self.setToolbarItems([deleteAllButtonItem], animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        #if DEBUG
        
        for x in 1...20 {
            self.noteArray.append("new note #\(x)")
        }
        self.tableView.reloadData()
        #endif
    }
    
    @objc func deleteAllButtonTapped(_ sender: UIBarButtonItem) {
        print("deleteAllButton was tapped")
        self.noteArray.removeAll()
        self.tableView.reloadData()
        super.setEditing(false, animated: true)
        self.tableView.setEditing(false, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        print("addbutton was tapped")
        
        let newNote = "Added Note #\(self.noteArray.count + 1)"
        self.noteArray.insert(newNote, at: 0)
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
        self.tableView.reloadData()
        
        if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
            self.tableView.deselectRow(at: IndexPath(row: selectedRow, section: 0), animated: true)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        navigationController?.setToolbarHidden(!editing, animated: true)
        navigationItem.rightBarButtonItem = editing ? nil : addButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = self.noteArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.noteArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            print("handle an insert?")
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ROW SELECTED: #\(indexPath.row)")
    }
 
}

