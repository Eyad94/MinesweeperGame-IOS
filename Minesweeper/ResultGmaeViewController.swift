//
//  ResultGmaeViewController.swift
//  Minesweeper
//
//  Created by Ali on 1/04/2019.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit

class ResultGmaeViewController: UIViewController {

    var Result = ""
    @IBOutlet var ResultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ResultLabel.text = Result

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func PlayAgainButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func ScoresButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ScoresViewController")as? ScoresViewController{
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    


}
