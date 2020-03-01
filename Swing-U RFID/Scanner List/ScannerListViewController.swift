//
//  ScannerListViewController.swift
//  Swing-U RFID
//
//  Created by Hamza Öztürk on 29.02.2020.
//  Copyright © 2020 Busoft. All rights reserved.
//

import UIKit

class ScannerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var swingprotocol: SwingProtocol!
    var dbinstance: DBInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swingprotocol = SwingProtocol.sharedInstace() as! SwingProtocol
        swingprotocol.delegate = self
        
        if swingprotocol.isSwingrederConnected() {
            print("device is connected")
        } else {
            print("device is not connected")
        }
        
        dbinstance = DBInterface(dataBaseFilename: "rfid_items.db")
        dbinstance.createDatabase()
        
        if let device = UserDefaults.standard.object(forKey: "c_device") {
            swingprotocol.aryDevices.add(device)
        }
    }
    
    @IBAction func scan(_ sender: Any) {
        swingprotocol.aryDevices.removeAllObjects()
        tableView.reloadData()
        
        swingprotocol.swingapi.scan()
    }
}

extension ScannerListViewController: SwingProtocolProtocol {
    func swing_didDiscover(_ dev: SwingDevice!) {
        tableView.reloadData()
    }
    
    func swing_didconnectedDevice(_ dev: SwingDevice!) {
        print("Device is connected = \(String(describing: dev.name))")
    }
    
    func swing_ready(toCommunicate dev: SwingDevice!) {
        print("connected SwingU-\(String(describing: dev.macaddress))")
    }
    
    func swing_didDisconnectDevice(_ dev: SwingDevice!) {
        print("disconnected SwingU-\(String(describing: dev.macaddress))")
    }
    
    func readerStatus() -> Bool {
        return false
    }
    
    func reciveData(_ result: String!) {
        
    }
}

extension ScannerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        swingprotocol.aryDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerListCell", for: indexPath)
        let peripheral = swingprotocol.aryDevices.object(at: indexPath.row) as! SwingDevice
        
        cell.textLabel?.text = peripheral.name
        cell.detailTextLabel?.text = peripheral.identifier
        
        return cell
    }
}

extension ScannerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let device = swingprotocol.aryDevices.object(at: indexPath.row) as! SwingDevice
        
        if swingprotocol.swingDev == nil {
            swingprotocol.swingDev = device
            swingprotocol.swingapi.connect(to: swingprotocol.swingDev)
            print("device connect \(String(describing: swingprotocol.swingDev.macaddress))")
        }
        else if device == swingprotocol.swingDev {
            if !swingprotocol.swingDev.bReadyToWrite {
                swingprotocol.swingapi.connect(to: swingprotocol.swingDev)
                print("connect device \(String(describing: swingprotocol.swingDev.macaddress))")
            }else if swingprotocol.swingDev.bReadyToWrite {
                print("disconnect device \(String(describing: swingprotocol.swingDev.macaddress))")
                swingprotocol.swingapi.disconnect(to: swingprotocol.swingDev)
                swingprotocol.swingDev = nil
            }
        } else{
            if swingprotocol.swingDev.bReadyToWrite {
                print("disconnect device \(String(describing: swingprotocol.swingDev.macaddress))")
                swingprotocol.swingapi.disconnect(to: swingprotocol.swingDev)
                swingprotocol.swingDev = device
                swingprotocol.swingapi.connect(to: swingprotocol.swingDev)
                print("connect device \(String(describing: swingprotocol.swingDev.macaddress))")
            } else {
                swingprotocol.swingapi.connect(to: swingprotocol.swingDev)
                print("connect device \(String(describing: swingprotocol.swingDev.macaddress))")
            }
            
        }
    }
}
