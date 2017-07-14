//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by William Oanta on 13/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class LocationsTableViewController: OnMapViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
       self.automaticallyAdjustsScrollViewInsets = false
       self.reloadTable()
    }
    
    func reloadTable() {
        self.activityIndicator.startAnimating()
        self.getStudentLocations { success in
            performUIUpdatesOnMain {
                self.table.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell") as UITableViewCell!
        let location = StudentLocations.sharedInstance().locations[(indexPath as NSIndexPath).row]

        /* Set cell */
        cell?.textLabel!.text = location.firstName + " " + location.lastName
        
        cell?.imageView!.image = UIImage(named: "icon_pin")

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.sharedInstance().locations.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = StudentLocations.sharedInstance().locations[(indexPath as NSIndexPath).row]
        UIApplication.shared.open(URL(string: location.mediaURL)!)
    }
    
    // MARK: - Actions
    
    @IBAction func onLogoutPressed(_ sender: Any) {
        self.logout()
    }

    @IBAction func onRefreshPressed(_ sender: Any) {
        self.reloadTable()
    }
}
