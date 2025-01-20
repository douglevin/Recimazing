//
//  Item.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
