//
//  DetailViewController.swift
//  DevNotes
//
//  Created by Kenneth Dait on 7/20/20.
//  Copyright © 2020 kenanigans. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var textView: UITextView!
    
    var masterVC: NoteLibrary?
    var selectedRow: Int?
    var initNote: Note?

    override func viewDidLoad() {
        
        guard let masterVC = self.masterVC, let initNote = self.initNote else { fatalError() }
        super.viewDidLoad()

        textView = UITextView(frame: view.bounds)
        self.view.addSubview(textView)
        
        self.textView.text = initNote.contents
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let masterVC = self.masterVC,
              let initNote = self.initNote,
              let selectedRow = self.selectedRow else { fatalError() }
        
        textView.resignFirstResponder()
        
        var returnNote = initNote
        returnNote.contents = textView.text
        masterVC.noteArray[selectedRow] = returnNote
        masterVC.tableView.reloadData()
    }
    

    func initializeDetailView(_ sender: NoteLibrary, selectedRow: Int, initNote: Note) {
        self.masterVC = sender
        self.initNote = initNote
        self.selectedRow = selectedRow
    }

}
