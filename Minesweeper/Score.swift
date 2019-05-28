//
//  Score.swift
//  Minesweeper
//
//  Created by Ali on 5/05/2019.
//  Copyright © 2019 Afeka. All rights reserved.
//

import Foundation
import CoreLocation

class Score :NSObject,NSCoding {
    var level: String
    var name:String
    var time:Int
    var latitude: Double
    var longitude: Double
    
    static let RECORDS_NAME_FILE = "MinesweeperScoresTable"
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.level, forKey: "level")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode("\(self.time)", forKey: "time")
        aCoder.encode("\(self.latitude)", forKey: "latitude")
        aCoder.encode("\(self.longitude)", forKey: "longitude")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let level = (aDecoder.decodeObject(forKey: "level") as? String), let name = aDecoder.decodeObject(forKey: "name") as? String, let time = aDecoder.decodeObject(forKey: "time") as? String, let latitude = aDecoder.decodeObject(forKey: "latitude") as? String, let longitude = aDecoder.decodeObject(forKey: "longitude") as? String else { return nil }
        self.level = level
        self.name = name
        self.time = Int(time) ?? -1
        self.latitude = Double(latitude) ?? 0
        self.longitude = Double(longitude) ?? 0
        
    }
    
    init(level:String,name:String,time:Int, latitude: Double, longitude: Double) {
        self.level = level
        self.name = name
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    static func loadFromDisk() -> [Score]?{
        if let data = UserDefaults.standard.object(forKey: RECORDS_NAME_FILE) as? Data, let scores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Score]
        {
            return scores
        }
        return nil
    }
    
    static func save(score:Score){
        var scores:[Score]? = loadFromDisk()
        if scores != nil{
 
            scores?.append(score)
            scores?.sort{$0.time < $1.time}
        }
        else
        {
            scores = [score]
        }
        
        saveToFile(scores: scores!)
    }
    
    static func saveToFile(scores:[Score]){
        var tempScores = scores
        if scores.count != nil , scores.count > 10
        {
            tempScores.remove(at: scores.count-1)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: tempScores)
        UserDefaults.standard.set(data, forKey: RECORDS_NAME_FILE)
        
    }
    
    
    
}





    

