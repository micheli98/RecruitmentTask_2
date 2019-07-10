//
//  TableViewController.swift
//  ReruitmentTask
//
//  Created by Magnise on 7/8/19.
//  Copyright © 2019 Magnise. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var livesData: UILabel!
    @IBOutlet weak var dateData: UILabel!
    @IBOutlet weak var fromData: UILabel!
    @IBOutlet weak var educData: UILabel!
    @IBOutlet weak var phoneData: UILabel!
    @IBOutlet weak var biographyData: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.loadProfile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 55
        loadImage()
    }
    
    @IBAction func refreshCotrolAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.loadProfile()
        }
    }
    
    func loadImage() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            let imgData = defaults.object(forKey: "profileImg") as? Data
            
            if imgData != nil {
                self.imageView.image = UIImage(data: imgData!)
            } else if let url = URL(string: "https://i.pinimg.com/originals/43/f9/07/43f90790a622f7af320e254686f6243f.jpg") {
                if let data = try? Data(contentsOf: url) {
                    self.imageView.image = UIImage(data: data)
                    let image = self.imageView.image!
                    let imgData = image.pngData()
                    let defaults = UserDefaults.standard
                    
                    defaults.set(imgData, forKey: "profileImg")
                }
            }
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
                
                labelName.text = "Elon Musk"
                livesData.text = "Lives in " + data[0]
                dateData.text = "Born on " + data[1]
                fromData.text = "From " + data[2]
                educData.text = "Studied at " + data[3]
                
                if (data[4].count == 10) {
                    phoneData.text = "+38" + data[4]
                } else {
                    phoneData.text = "+" + data[4]
                }
                
                biographyData.text = data[5]
            } catch { }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return 8
    }

}
