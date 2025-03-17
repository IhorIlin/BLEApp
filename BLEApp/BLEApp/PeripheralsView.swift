//
//  PeripheralsView.swift
//  BLEApp
//
//  Created by Ihor Ilin on 14.03.2025.
//

import SwiftUI

struct PeripheralsView: View {
    @ObservedObject var viewModel: PeripheralsViewModel = .init()
    
    var body: some View {
        NavigationView {
            List(viewModel.discoveredPeripherals, id: \.self) { peripheral in
                Text(peripheral.name)
            }
            .navigationBarTitle("Peripherals")
        }
    }
}

#Preview {
    PeripheralsView()
}
