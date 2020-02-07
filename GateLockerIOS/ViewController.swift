//
//  ViewController.swift
//  GateLockerIOS
//
//  Created by Bùi Đức on 2/6/20.
//  Copyright © 2020 bhd. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet var myTextView: UITextView!
    @IBOutlet var myButton: UIButton!
    
    let ip = ["192.168.1.222", "192.168.1.223","192.168.1.224","192.168.1.225"]
    let name = ["BHD", "BAK", "BVT", "NTTN"]
    
    func findIP(curIP: String) -> Int{
        var i = 0
        while i < ip.count{
            if (ip[i] == curIP){
                return i
            }
            i += 1
        }
        
        return -1
    }
    
    func getTextViewText(){
        //clear textView text
        myTextView.text = ""
        
        //access to database to get text
        var ref: DatabaseReference!

        ref = Database.database().reference()
        ref.child("peopleInHome").observe(DataEventType.value, with: { (snapshot) in
            // Get all ip text
            let text = snapshot.value as? String
            
            //split it
            let token = text?.split(separator: " ")
            
            //get title
            self.myTextView.text = "There are " + String(token!.count) + " people in home: \n"
             
            for cur in token ?? [""] {
                
                //find ip in known ip
                let pos = self.findIP(curIP: String(cur))
                
                if (pos == -1){
                    self.myTextView.text = (self.myTextView.text ?? "") + String(cur) + "\n"
                } else{
                    self.myTextView.text = (self.myTextView.text ?? "") + String(self.name[pos]) + "\n"
                }
            }
          })
    }
    
    func getButtonText(){
        //access to database to get text
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        ref.child("status").observe(DataEventType.value, with: { (snapshot) in
          // Get status value
            let text = snapshot.value as? String
            
            if (text == "ON"){
                self.myButton.setTitle("TURN OFF", for: UIControl.State.normal)
            } else{
                self.myButton.setTitle("TURN ON", for: UIControl.State.normal)
            }
          })
    }
    
    @IBAction func onMyButtonClicked(_ sender: UIButton) {
        //access to database to set text
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        if (self.myButton.titleLabel?.text == "TURN ON"){
            //send text to database
            ref.child("status").setValue("ON")
            
            //text of button will automatic change base on getButtonText()
        } else{
            //send text to database
            ref.child("status").setValue("OFF")
            
            //text of button will automatic change base on getButtonText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getButtonText()
        getTextViewText()
    }

}

