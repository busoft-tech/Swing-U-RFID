//
//  ScannerSettingViewController.swift
//  Swing-U RFID
//
//  Created by Hamza Öztürk on 29.02.2020.
//  Copyright © 2020 Busoft. All rights reserved.
//

import UIKit

class ScannerSettingViewController: UITableViewController {
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var continuousModeLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    @IBOutlet weak var chargingStatusLabel: UILabel!
    @IBOutlet weak var reportModeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var powerLevelLabel: UILabel!
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var stepUnitLabel: UILabel!
    @IBOutlet weak var inventoryModeLabel: UILabel!
    @IBOutlet weak var lcdModeLabel: UILabel!
    @IBOutlet weak var storedTagListCountLabel: UILabel!
    @IBOutlet weak var maxEpcLengthLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    var swingPtc: SwingProtocol!
    var rfidPower = Array(3...30)
    var session = Array(0...2)
    var threshold = Array(0...30)
    var reduction = Array(0...6)
    var volume = ["Vibration", "Mute", "Low", "Normal", "MAXVolume"]
    var maxEpcLength = ["512", "384", "288", "192", "128", "96"]
    var filterSize = ["MAX", "1024", "2048", "4096", "8192"]
    var language = ["English", "中文", "日本語"]
    var model = ["No Barcode", "1D Barcode", "2D Barcode"]
    override func viewDidLoad() {
        super.viewDidLoad()

        swingPtc = SwingProtocol.sharedInstace() as! SwingProtocol
        swingPtc.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        swing_get_info()
        swing_get_language()
    }
    
    private func swing_get_info() {
        swingPtc.swing_getAllInformation()
    }
    
    private func swing_get_language() {
        swingPtc.swing_getLanguage()
    }
}

extension ScannerSettingViewController: SwingProtocolProtocol {
    func readerStatus() -> Bool {
        return false
    }
    
    func reciveData(_ result: String!) {
        print("revice data = \(String(describing: result))")
    }
    
    func swing_Response_model(_ value: String!) {
        modelLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_name(_ value: String!) {
        nameLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_version(_ value: String!) {
        versionLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_continuous(_ value: String!) {
        continuousModeLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_battery(_ value: String!) {
        batteryLevelLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_charging(_ value: String!) {
        chargingStatusLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_mode_trigger_alltag(_ value: String!) {
        reportModeLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_buzzer(_ value: String!) {
        volumeLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_power(_ value: String!) {
        powerLevelLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_threadhold(_ value: String!) {
        thresholdLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_Unit(_ value: String!) {
        stepUnitLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_InventoryMode(_ value: String!) {
        inventoryModeLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_TagCount(_ value: String!) {
        storedTagListCountLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_MaxEpcLength(_ value: String!) {
        maxEpcLengthLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_session(_ value: String!) {
        sessionLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_lcdMode(_ value: String!) {
        lcdModeLabel.text = value.components(separatedBy: " ")[1]
    }
    
    func swing_Response_Language(_ value: String!) {
        languageLabel.text = value.components(separatedBy: " ")[1]
    }
}
