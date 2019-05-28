//
//  ViewController.swift
//  Minesweeper
//
//  Created by Eyad on 4/1/19.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    var userName = ""
    var gameResult = ""
    var diffString = ""
    var timeCounter = 0
    var timer = Timer()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    let regionInMeters: Double = 10000
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minersLabel:UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionViewGame: UICollectionView!
    
    let edges = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 0.0, right: 2.0)
    var gameManager: GameManager!
    var gameSize: Int = 0
    var numOfMines: Int = 0
    var numOfFlags: Int = 0
    var minersLeft: Int = 0
    var difficult: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUP labels
        setTimer()
        setDifficult()
        
        nameLabel.text = userName
        minersLabel.text = "\(minersLeft) miners left"
        
        collectionViewGame.dataSource = self
        collectionViewGame.delegate = self
        gameManager = GameManager(gameSize: gameSize, numOfMines: numOfMines);
        self.numOfFlags = numOfMines
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionViewGame.addGestureRecognizer(lpgr)
        
        checkLocationServices()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Long Pressed
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            return
        }
        let pointClicked = gestureRecognizer.location(in: collectionViewGame);
        guard let indexPath = collectionViewGame.indexPathForItem(at: pointClicked) else {return}
        print("**********   long pressed   *************** ")
        if(numOfFlags > 0){
            let cells = gameManager.setFlagInCell(cellIndexPath: indexPath)
            numOfFlags -= cells.flags
            minersLabel.text = "\(numOfFlags) miners left"
            updateCollectionView(collectionView: collectionViewGame, indexPathArr: cells.cellsChanged);
        }
    }
    
    
    
    func setTimer(){
        
        //timer = Timer.scheduledTimer(timeInterval: 1,target: self,selector:, #selector(self.updateTimer)
        //,userInfo: nil,repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    
    func updateTimer(){
        
        timeCounter+=1
        
        let hours = Int(timeCounter)/3600
        let minutes = Int(timeCounter)/60 % 60
        let secends = Int(timeCounter)%60
        
        if(hours > 24){
            gameResult = "Loose"
            endGame()
        }
        
        if(hours < 1){
            
            if(minutes < 1){
                timerLabel.text = String(format: "%02i" , secends)
            }
            else{
                timerLabel.text = String(format: "%02i:%02i" , minutes , secends)
            }
        }
        else{
            timerLabel.text = String(format: "%02i:%02i:%02i" , hours , minutes , secends)
            
        }
        
    }
    
    
    func updateCollectionView(collectionView: UICollectionView, indexPathArr: [IndexPath]) {
        collectionView.reloadItems(at: indexPathArr)
    }
    
    
    func setDifficult(){
        
        if(difficult == 1){
            gameSize = 5
            numOfMines = 5
            diffString = "Easy"
        }
        if(difficult == 2){
            gameSize = 10
            numOfMines = 20
            diffString = "Medium"

        }
        if(difficult == 3){
            gameSize = 10
            numOfMines = 30
            diffString = "Hard"

        }
        minersLeft = numOfMines
        
    }
    
    
    func endGame(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ResultGmaeViewController")as? ResultGmaeViewController{
    
            vc.Result = gameResult
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: - UICollectionView
    
    //Number of Rows in CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameSize
    }
    
    
    //Number of Cols in CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameSize
    }
    
    
    //Cell in CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let item = gameManager.getCellDataAt(indexPath: indexPath)

        cell.backgroundColor = ItemInCollectionView.cellColor(isCellOpen: item.IsCellOpen())
        cell.updateItemInCollectionView(item: item)
        
        return cell
    }
    
    
    // mouse clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellsChanged = gameManager.clickOnCell(cellIndexPath: indexPath)
        updateCollectionView(collectionView: collectionView, indexPathArr: cellsChanged)
        
        if(gameManager.gameOver == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                
                //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ must delete
                let s = Score(level: self.diffString , name: self.userName , time: self.timeCounter , latitude: self.latitude  , longitude: self.longitude)
                Score.save(score: s)
                //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ must delete

                self.gameResult = "Lose"
                self.endGame()
            }
        }
        
        if(gameManager.winGame == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                //----------------------------------------------- save user check in to get to table later in the score save method
                //let s = Score(level: self.diffString , name: self.userName , time: self.timeCounter , latitude: self.latitude  , longitude: self.longitude)
                //Score.save(score: s)

                self.gameResult = "Winner"
                self.endGame()
            }
        }
    }

    
    // MARK: - FlowLayout
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeOfGame = CGFloat(gameSize)
        let paddingSpace = edges.left * (sizeOfGame + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let cellWidth = availableWidth / sizeOfGame
        return CGSize(width: cellWidth, height: cellWidth)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return edges.left
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edges.left
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return edges
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    
    func setupLocationManager() {
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    

}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdate")
        
        guard let location = locations.last else { return }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
    
    
}














