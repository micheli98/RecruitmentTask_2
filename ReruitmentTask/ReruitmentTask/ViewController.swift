//
//  ViewController.swift
//  ReruitmentTask
//
//  Created by Magnise on 7/8/19.
//  Copyright © 2019 Magnise. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var livesData: UITextField!
    @IBOutlet weak var dateData: UITextField!
    @IBOutlet weak var fromData: UITextField!
    @IBOutlet weak var educData: UITextField!
    @IBOutlet weak var phoneData: UITextField!
    @IBOutlet weak var biographyData: UITextView!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerForKeyboardNotifications()
        phoneData.delegate = self
        loadProfile()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateData.inputView = datePicker
        datePicker?.minimumDate = Calendar.current.date(byAdding: .year, value: -200, to: Date())
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        saveToFile()
    }
    
    func saveToFile() {
        let fileName = "profileData"
        var data = " "
        
        data = livesData.text! + "\n" + dateData.text! + "\n" +
               fromData.text!  + "\n" + educData.text! + "\n" +
               phoneData.text! + "\n" + biographyData.text!
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            
            print(fileURL)
            
            do {
                try data.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch { }
        }
    }
    
    func loadProfile() {
        let fileName = "profileData"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            
            print(fileURL)
            
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                let data = text.components(separatedBy: .newlines)

                livesData.text = data[0]
                dateData.text = data[1]
                fromData.text = data[2]
                educData.text = data[3]
                
                if (data[4].count == 10) {
                    phoneData.text = "38" + data[4]
                } else {
                    phoneData.text = data[4]
                }
                
                biographyData.text = data[5]
            } catch { }
        }
    }
    
    @objc func viewTapped(gestureecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateData.text = dateFormatter.string(from: datePicker.date)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow (_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

///Users/magnise/Documents/ReruitmentTask
