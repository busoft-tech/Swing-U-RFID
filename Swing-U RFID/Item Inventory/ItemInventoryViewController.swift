//
//  ItemInventoryViewController.swift
//  Swing-U RFID
//
//  Created by Hamza Öztürk on 29.02.2020.
//  Copyright © 2020 Busoft. All rights reserved.
//

import UIKit

class ItemInventoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultTest: UILabel!
    
    var swingPtc: SwingProtocol!
    var newsArray = [InventoryItems]()
    var tagMarge = ""
    var tagAlllist = [String]()
    var tablecount = 0
    var readonoff = false
    
    private lazy var startButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(startStop))
    }()
    
    private lazy var stopButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(startStop))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swingPtc = SwingProtocol.sharedInstace() as! SwingProtocol
        swingPtc.delegate = self
        
        swingPtc.swing_set_inventory_mode(0) //Inventory Normal Mode
    
        navigationItem.rightBarButtonItem = startButton
    }
    
    @objc private func startStop() {
        if readonoff {
            swingPtc.swing_readStop()
            navigationItem.rightBarButtonItem = startButton
        } else {
            swingPtc.swing_readStart()
            navigationItem.rightBarButtonItem = stopButton
        }
        
        readonoff.toggle()
    }
    
    @IBAction func clearList(_ sender: Any) {
        newsArray.removeAll()
        tableView.reloadData()
        swingPtc.swing_clear_inventory()
    }
    
    private func readTag(result: String) {
        tagMarge = String(result.prefix(result.count - 1))

        if let replaceRange = tagMarge.range(of: ">T") {
            tagMarge = tagMarge.replacingCharacters(in: replaceRange, with: "")
        }
        if let replaceRange = tagMarge.range(of: ">J") {
            tagMarge = tagMarge.replacingCharacters(in: replaceRange, with: "")
        }
        
        var newTag = false
        
        for inventoryItem in newsArray {
            if inventoryItem.tagId == tagMarge {
                inventoryItem.count += 1
                newTag = true
                break
            }
        }
        
        if !newTag {
            let temp = InventoryItems()!
            temp.tagId = tagMarge
            temp.count = 1
            temp.lat = "Non"
            temp.lng = "Non"
            temp.name = "No Name"
            temp.search = false
            newsArray.append(temp)
        }
        
        tableView.reloadData()
    }
}

extension ItemInventoryViewController: SwingProtocolProtocol{
    func readerStatus() -> Bool {
        return false
    }
    
    func reciveData(_ result: String!) {
        
    }
    
    func swing_Response_InventoryCmd(_ value: String!) {
        print(value)
    }
    
    func swing_Response_InventoryCmd_Stop(_ value: String!) {
        readonoff = false
        navigationItem.rightBarButtonItem = startButton
    }
    
    func swing_Response_InventoryCmd_Start(_ value: String!) {
        readonoff = true
        navigationItem.rightBarButtonItem = stopButton
    }
    
    func swing_Response_TagList(_ value: String!) {
        let result = value.trimmingCharacters(in: CharacterSet.whitespaces)

        resultTest.text = result
        readTag(result: result)
    }
}

extension ItemInventoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemInventoryCell", for: indexPath)
        
        let temp = newsArray[indexPath.row]
        
        cell.textLabel?.text = temp.tagId
        cell.detailTextLabel?.text = String(format: "%ld", temp.count)
        
        return cell
    }
}
