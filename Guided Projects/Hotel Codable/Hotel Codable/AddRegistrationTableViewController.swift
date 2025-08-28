//
//  AddRegistrationTableViewController.swift
//  Hotel Codable
//
//  Created by student on 27/08/25.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    func selectRoomTypeTableViewControllerDidSelect(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    
    @IBOutlet weak var numberofAdultsStepper: UIStepper!
    @IBOutlet weak var numberofAdultsLabel: UILabel!
    @IBOutlet weak var numberofChildrenLabel: UILabel!
    @IBOutlet weak var numberofChilderStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        return selectRoomTypeController
    }
    
    
    var roomType: RoomType?
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        }
        else {
            roomTypeLabel.text = "No Room Selected"
        }
    }
    
    func updateNumberOfGuests(){
        numberofAdultsLabel.text = "\(Int(numberofAdultsStepper.value))"
        numberofChildrenLabel.text = "\(Int(numberofChilderStepper.value))"
    }
    

    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)

    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    @IBAction func doneBarButtonTapped(_ sender: Any) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberofAdultsStepper.value)
        let numberOfChildren = Int(numberofChilderStepper.value)
        let hasWifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? "No Room Selected"
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("Number Of Adults: \(numberOfAdults)")
        print("Number Of Children: \(numberOfChildren)")
        print("Wi-Fi: \(hasWifi)")
        print("Roomtype: \(roomChoice)")
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    var registration: Registration? {
        
        guard let roomType = roomType else { return nil }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberofAdultsStepper.value)
        let numberOfChildren = Int(numberofChilderStepper.value)
        let hasWiFi = wifiSwitch.isOn
        
        return Registration(
            firstName: firstName,
            lastName: lastName,
            emailAddress: email,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfChildren: numberOfChildren,
            numberOfAdults: numberOfAdults,
            wifi: hasWiFi,
            roomType: roomType
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: midnightToday)!
        
        updateNumberOfGuests()
        updateDateViews()
        checkInDatePicker.isHidden = true
        checkOutDatePicker.isHidden = true
        updateRoomType()
  
    }
    
    func updateDateViews() {
        checkInDateLabel.text =
        checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text =
        checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath {
            isCheckInDatePickerVisible.toggle()
            if isCheckInDatePickerVisible {
                isCheckOutDatePickerVisible = false
            }
        } else if indexPath == checkOutDateLabelCellIndexPath {
            isCheckOutDatePickerVisible.toggle()
            if isCheckOutDatePickerVisible {
                isCheckInDatePickerVisible = false
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
            case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
            case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension

        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
}
