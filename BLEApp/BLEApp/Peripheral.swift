//
//  Peripheral.swift
//  BLEApp
//
//  Created by Ihor Ilin on 17.03.2025.
//

import Foundation

struct Peripheral: Identifiable, Hashable {
    var id: UUID = UUID()
    
    let name: String
}
