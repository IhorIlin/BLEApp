//
//  PeripheralsViewModel.swift
//  BLEApp
//
//  Created by Ihor Ilin on 14.03.2025.
//

import CoreBluetooth

final class PeripheralsViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager
    private var peripherals: [CBPeripheral] = []
    
    @Published var discoveredPeripherals: [Peripheral] = []
    @Published var currentPeripheral: CBPeripheral?
    
    override init() {
        centralManager = CBCentralManager()
        
        super.init()
        
        centralManager.delegate = self
    }
    
    private func scan() {
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func connectToPeripheral(_ peripheral: CBPeripheral) {
        currentPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
}

extension PeripheralsViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
            scan()
        case .poweredOff:
            // TODO: go to settings
            break
        case .resetting:
            break
        case .unauthorized:
            break
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
            discoveredPeripherals.append(Peripheral(name: peripheral.name ?? "Unknown"))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension PeripheralsViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        service.characteristics?.forEach {
            if let value = $0.value {
                print(String(data: value, encoding: .utf8) as Any)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
}
