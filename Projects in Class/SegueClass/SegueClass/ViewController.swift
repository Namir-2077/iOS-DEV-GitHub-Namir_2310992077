//
//  ViewController.swift
//  SegueClass
//
//  Created by student on 18/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
@IBAction func unwindToRedViewController(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.navigationItem.title = textField.text
    }

    @IBAction func goToyellowButtonTaped(_ sender: UIButton) {
        if toggleSwitch.isOn {
            performSegue(withIdentifier: "Green", sender: nil)
        }
    }
}

