//
//  ScoresViewController.swift
//  Minesweeper
//
//  Created by Eyad on 5/05/19.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ScoresViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    
    
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var ScoreMapView: MKMapView!
    @IBOutlet weak var ScoreTableView: UITableView!
    
    
    //ScoreMapView
    var difficult: Int = 0
    let regionInMeters: Double = 10000

    
    let locationManager = CLLocationManager()
 
    
    static var difficulty = "Easy"

    var data:[Score]?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ScoreTableView.tableFooterView = UIView()
        ScoreTableView.delegate = self
        ScoreTableView.dataSource = self
        
        data = Score.loadFromDisk()
    
        
        findUserLocationAndDropPin()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ButtonBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    //*************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell") as! ScoreCell
        cell.name.text = data?[indexPath.row].name
        cell.score.text = "\(data?[indexPath.row].time ?? -1)s"
        
        

        cell.index.text = "\(indexPath.row + 1)."
        return cell
    }
    //*************************
    
    
    
    func findUserLocationAndDropPin() {
        MKPointAnnotation()
        if data != nil {
            for i in 0..<data!.count{
                let latitude = data![i].latitude
                let longitude = data![i].longitude
                let userLocationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
                print("\n\(latitude)\n")
                print(longitude)
                let pinForUserLocation = MKPointAnnotation()
                pinForUserLocation.coordinate = userLocationCoordinates
                pinForUserLocation.title =  data![i].name
                pinForUserLocation.subtitle = "\(data![i].time)s"
                ScoreMapView.addAnnotation(pinForUserLocation)
                ScoreMapView.showAnnotations([pinForUserLocation], animated: true)
                
            }
            
            //mapView.showAnnotations([pinForUserLocation], animated: true)
        }
    }

    
    
    
    
    
    
   
    
    
  


}




    
    

