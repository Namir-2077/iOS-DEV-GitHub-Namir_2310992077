//
//  TableViewController.swift
//  Emoji Table View
//
//  Created by student on 21/08/25.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Data source with save on change
    var emojis: [Emoji] = [] {
        didSet {
            Emoji.saveToFile(emojis: emojis)
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Load saved emojis or use sample emojis if none saved
        let savedEmojis = Emoji.loadFromFile()
        if savedEmojis.isEmpty {
            emojis = Emoji.emojis
        } else {
            emojis = savedEmojis
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Segue Action for Add/Edit
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditTableViewController? {
        guard let indexPath = sender as? IndexPath else {
            return AddEditTableViewController(coder: coder, emoji: nil)
        }
        return AddEditTableViewController(coder: coder, emoji: emojis[indexPath.row])
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        let emoji = emojis[indexPath.row]
        content.text = "\(emoji.symbol) - \(emoji.name)"
        content.secondaryText = emoji.description
        
        cell.contentConfiguration = content
        cell.showsReorderControl = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "editSegue", sender: indexPath)
    }
    
    // MARK: - Editing support

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = emojis.remove(at: fromIndexPath.row)
        emojis.insert(movedEmoji, at: to.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // MARK: - Unwind segue from Add/Edit

    @IBAction func unwindToEmojiTVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue",
              let addEditTVC = segue.source as? AddEditTableViewController,
              let emoji = addEditTVC.emoji else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Editing existing emoji
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            // Adding new emoji
            emojis.append(emoji)
            let indexPath = IndexPath(row: emojis.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
}
