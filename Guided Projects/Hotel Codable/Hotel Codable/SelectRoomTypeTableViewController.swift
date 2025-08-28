//
//  SelectRoomTypeTableViewController.swift
//  Hotel Codable
//
//  Created by Student on 28/08/25.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    func selectRoomTypeTableViewControllerDidSelect(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
        
        var roomType : RoomType?
        
        weak var delegate: SelectRoomTypeTableViewControllerDelegate?
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let roomType = RoomType.all[indexPath.row]
            self.roomType = roomType
            delegate?.selectRoomTypeTableViewControllerDidSelect(self, didSelect: roomType)
            tableView.reloadData()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "\(roomType.price) per night"
        cell.contentConfiguration = content
        
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
 }
