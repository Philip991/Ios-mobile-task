//
//  Item.swift
//  mobile task
//
//  Created by Philip Oma on 14/08/2024.
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
