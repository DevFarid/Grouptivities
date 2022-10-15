//
//  Post.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/14/21.
//

import Foundation

struct Post {
    
    let UUID: String
    let addedByUser: String
    let title: String
    let date: String
    let description: String
    var modifiedOn: String?
    
    // When post is first created.
    init(id: String, user: String, title: String, date: String, content: String, lastModifiedOn: String?) {
        self.UUID = id
        self.addedByUser = user
        self.title = title
        self.date = date
        self.description = content
        guard let modificationHistory = lastModifiedOn else { return }
        self.modifiedOn = modificationHistory
    }
    
    init() {
        self.UUID = String()
        self.addedByUser = String()
        self.title = String()
        self.date = String()
        self.description = String()
        self.modifiedOn = nil
    }
    
    
}
