//
//  ViewController.swift
//  DevNotes
//
//  Created by Kenneth Dait on 7/20/20.
//  Copyright © 2020 kenanigans. All rights reserved.
//

import UIKit

class NoteLibrary: UITableViewController {
    
    var noteArray = [Note]()
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
            let newNote = Note("new note #\(x)")
            self.noteArray.append(newNote)
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
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        print("addbutton was tapped")
        
        let newNote = Note("Added Note #\(self.noteArray.count + 1)")
        self.noteArray.insert(newNote, at: 0)
        
        if self.noteArray.count == 1 {
            if navigationItem.leftBarButtonItem == nil {
                navigationItem.leftBarButtonItem = editButtonItem
            }
        }
        
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
        
        if !editing && self.noteArray.count == 0 {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.noteArray.indices.contains(indexPath.row) else { fatalError() }
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "noteCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        
        let targetNote = self.noteArray[indexPath.row]
        cell.textLabel?.text = targetNote.contents
        cell.detailTextLabel?.text = targetNote.noteID.uuidString
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingNote = self.noteArray.remove(at: sourceIndexPath.row)
        self.noteArray.insert(movingNote, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ROW SELECTED: #\(indexPath.row)")
        guard self.noteArray.indices.contains(indexPath.row) else { fatalError() }
        let initNote = self.noteArray[indexPath.row]
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            tableView.deselectRow(at: IndexPath(row: selectedRow, section: 0), animated: true)
            let detailVC = DetailViewController()
            detailVC.initializeDetailView(self, selectedRow: selectedRow, initNote: initNote)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
 
}

