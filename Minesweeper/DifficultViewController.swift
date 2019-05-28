//
//  DifficultViewController.swift
//  Minesweeper
//
//  Created by Ali on 4/04/2019.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit
import CoreLocation


class DifficultViewController: UIViewController {

    var userName = ""
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func EasyButton(_ sender: UIButton) {
        sender.shake()
        StartGame(difficult: 1)
    }
    
    
    @IBAction func MeduimButton(_ sender: UIButton) {
        sender.pulsate()
        StartGame(difficult: 2)

    }
    
    
    @IBAction func HardButton(_ sender: Any) {
        StartGame(difficult: 3)

    }
    
    
    func StartGame(difficult: Int){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")as? ViewController{
            
            
            vc.userName = userName
            vc.difficult = difficult
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @IBAction func ScoresButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ScoresViewController")as? ScoresViewController{
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}



