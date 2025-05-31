//
//  ViewController.swift
//  DarwinNotificationProducer
//
//  Created by Anand Kumar on 5/23/25.
//

import notify
import UIKit

class ViewController: UIViewController {
    
    var postCounter = 0
    var lastPostedValue = 0
    
    let notificationName = "com.example.myNotification"
    
    @IBOutlet weak var startingValueTextfield: UITextField!
    @IBOutlet weak var postedValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonATapped(_ sender: Any) {
        resgisterCheck_SetState_Post()
    }

    /*
     1. Register with `notify_register_check`
     2. Set state with `notify_set_state`
     3. Post with `notify_post`
     4. Cancel with `notify_cancel`
     */
    func resgisterCheck_SetState_Post() {
        let valueToBePosted: Int = {
            if postCounter == 0 {
                return startingValueTextfield.text.flatMap { Int($0) } ?? 1
            } else {
                return lastPostedValue + 1
            }
        }()
        
        if postCounter == 0 {
            startingValueTextfield.isEnabled = false
        }
        
        
        var notificationRegistrationID: Int32 = 0       // This thing is called token in Darwin parlance
        let notificationAssociatedData: UInt64 = UInt64(valueToBePosted)       // This thing is called state in Darwin parlance
        
        let notificationRegistrationResult: UInt32 = notificationName.withCString {
            notify_register_check($0, &notificationRegistrationID)
        }
        
        guard notificationRegistrationResult == 0 else {
            print("\(Date().description) - Failed to register and get an ID/token")
            return
        }
        
        let setStateResult = notify_set_state(notificationRegistrationID, notificationAssociatedData)
        
        guard setStateResult == 0 else {
            print("Failed to set state)")
            return
        }
        
        notify_post(notificationName)       // A notify_post is not essential if all that is needed is to set and get a state
        lastPostedValue = valueToBePosted
        postedValueLabel.text = "Posted \(notificationAssociatedData)"
        print("\(Date().description) Darwin notification '\(notificationName)' posted with state: \(notificationAssociatedData)")
        
        /* While notify_cancel() is recommended to be eventually done, keep in mind that if any register() from consumer has not happened, this will render the notifictaion ineffective as the state gets reset right away */
        //        notify_cancel(notificationRegistrationID)
        postCounter = postCounter + 1
    }
}

