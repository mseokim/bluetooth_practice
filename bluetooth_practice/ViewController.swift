//
//  ViewController.swift
//  bluetooth_practice
//
//  Created by 김민서 on 2017. 11. 14..
//  Copyright © 2017년 김민서. All rights reserved.
//

import UIKit
import CoreBluetooth


class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    

    var manager: CBCentralManager!
    var miBand: CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uuid = NSUUID().uuidString.lowercased()
        print(uuid)
        
        manager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

  
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("NAME : \(peripheral.name)")
        
        if peripheral.name == "김민서의 MacBook Pro" {
            self.miBand = peripheral
            self.miBand.delegate = self
            manager.stopScan()
            manager.connect(self.miBand, options: nil)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let servicePeripherals = peripheral.services as [CBService]! {
            for service in servicePeripherals {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characterArray = service.characteristics as [CBCharacteristic]! {
            for cc in characterArray {
                if cc.uuid.uuidString == "86a60114-c6c0-4531-83b0-dad0023e43a0" {
                    print("Schritte gefunden")
                    peripheral.readValue(for: cc)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid.uuidString == "86a60114-c6c0-4531-83b0-dad0023e43a0" {
            
            
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var consoleMsg = ""
        
        switch central.state {
        case .poweredOff:
            consoleMsg = "BLE is powered off"
            
        case .poweredOn:
            consoleMsg = "BLE is powered on"
            manager.scanForPeripherals(withServices: nil, options: nil)
            
            
        case .resetting:
            consoleMsg = "BLE is restting"
            
        case .unauthorized:
            consoleMsg = "BLE is unauthorized"
            
        case .unknown:
            consoleMsg = "BLE is unknown"
            
        case .unsupported:
            consoleMsg = "BLE is not supported"
            
        default:
            break
        }
        
        print("STAT: \(consoleMsg)")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

