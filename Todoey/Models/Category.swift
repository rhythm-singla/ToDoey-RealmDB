//
//  Category.swift
//  Todoey
//
//  Created by Rhythm Singla on 20/02/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
