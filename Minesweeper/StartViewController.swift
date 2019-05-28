//
//  StartViewController.swift
//  Minesweeper
//
//  Created by Ali on 1/04/2019.
//  Copyright © 2019 Afeka. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    var userName = ""
    
    @IBOutlet var userNameTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayAgainButton(_ sender: UIButton) {
        
        sender.shake()
        userName = userNameTextField.text!
        
        if(userName.isEmpty){
            
            // display alert message ,ust change***
            print("user name is empty?")
            
            let alert = UIAlertController(title: "alert", message: "name is empty", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert , animated: true , completion: nil)
            
            
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "DifficultViewController")as? DifficultViewController{
                
                vc.userName = userName
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

   
}
