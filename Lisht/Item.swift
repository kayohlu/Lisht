//
//  Item.swift
//  Lisht
//
//  Created by Karl Grogan on 10/07/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import CoreData

class Item: NSManagedObject {
    @NSManaged var text:String?
    
    init(text: String?) {
        self.text = text
    }
}
