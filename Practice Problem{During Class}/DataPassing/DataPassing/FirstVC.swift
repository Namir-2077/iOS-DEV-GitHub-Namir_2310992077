//
//  ViewController.swift
//  DataPassing
//
//  Created by student  on 11/08/25.
//

import UIKit

protocol DataPassing {
    func dataPassingToFirstVC(labelData: String?, sliderData: Float, textFieldData: String?)
}

class FirstVC: UIViewController, DataPassing {
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var firstTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func dataPassingToFirstVC(labelData: String?, sliderData: Float, textFieldData: String?) {
        firstTextField.text = labelData
        firstSlider.value = sliderData
        firstLabel.text = textFieldData
    }

    
    @IBSegueAction func passDataToSecondVC(_ coder: NSCoder) -> SecondVC? {
        let labelData = firstLabel.text
        let sliderData = firstSlider.value
        let textFieldData = firstTextField.text
        return SecondVC(coder: coder, labelData: labelData, sliderData: Float(sliderData), textFieldData: textFieldData, FirstVC: self)
    }
    
//    @IBAction func unwindToFirstVC(segue: UIStoryboardSegue) {
//        guard let secondVC = segue.source as? SecondVC else {
//            return
//        }
//        firstLabel.text = secondVC.secondTextField.text
//        firstTextField.text = secondVC.secondLabel.text
//        firstSlider.value = secondVC.secondSlider.value
//    }
    
}
