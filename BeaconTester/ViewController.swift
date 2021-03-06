//
//  ViewController.swift
//  BeaconTester
//
//  Created by Alper Cugun on 17/7/15.
//  Copyright (c) 2015 Alper Cugun. All rights reserved.
//

import UIKit
import CoreLocation

extension CLProximity {
    var sortIndex : Int {
        switch self {
        case .Immediate:
            return 0
        case .Near:
            return 1
        case .Far:
            return 2
        case .Unknown:
            return 3
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK : Properties
    @IBOutlet weak var tableView: UITableView!
    
    var fakeBeacons = ["Row1", "Row2", "Row3"]
    var beacons = [CLBeacon]()
    
    let ReuseIdentifier = "BeaconCell"
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e"), identifier: "SHACHI")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeaconsInRegion(region)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ReuseIdentifier)
        }
        
        var beacon = self.beacons[indexPath.row]
        
        var proximityString = ""
        switch beacon.proximity {
        case .Immediate:
            proximityString = "Immediate"
        case .Near:
            proximityString = "Near"
        case .Far:
            proximityString = "Far"
        case .Unknown:
                proximityString = "Unknown"
        }
        
        cell!.textLabel?.text = "Minor: \(beacon.minor) Range: \(proximityString)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        self.beacons = beacons as! [CLBeacon]
        
        self.beacons.sort({ $0.proximity.sortIndex < $1.proximity.sortIndex })
        
        self.tableView.reloadData()
    }
}

