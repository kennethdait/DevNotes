//
//  Note.swift
//  DevNotes
//
//  Created by Kenneth Dait on 7/20/20.
//  Copyright © 2020 kenanigans. All rights reserved.
//

import Foundation

struct Note {
    var contents: String
    let dateCreated: Date
    let noteID: UUID
}

extension Note {
    init(_ contents:String) {
        self.dateCreated = Date()
        self.contents = contents
        self.noteID = UUID()
    }
}
