//
//  SecondVC.swift
//  DataPassing
//
//  Created by student  on 11/08/25.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var secondTextField: UITextField!
    
    var labelData: String?
    var sliderData: Float?
    var textFieldData: String?
    var delegate: DataPassing?
    
    init?(coder: NSCoder, labelData: String?, sliderData: Float?, textFieldData: String?, FirstVC: FirstVC) {
        self.labelData = labelData
        self.sliderData = sliderData
        self.textFieldData = textFieldData
        self.delegate = FirstVC
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let labelData, let sliderData, let textFieldData {
            updateUI(labelData: labelData, sliderData: sliderData, textFieldData: textFieldData)
        }
        // Do any additional setup after loading the view.
    }
    
    func updateUI(labelData: String, sliderData: Float, textFieldData: String) {
        secondLabel.text = textFieldData
        secondSlider.value = sliderData
        secondTextField.text = labelData
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        delegate?.dataPassingToFirstVC(labelData: secondLabel.text, sliderData: secondSlider.value, textFieldData: secondTextField.text)
    }
    
}
