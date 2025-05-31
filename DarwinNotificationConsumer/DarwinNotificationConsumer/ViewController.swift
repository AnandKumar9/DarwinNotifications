//
//  ViewController.swift
//  DarwinNotificationConsumer
//
//  Created by Anand Kumar on 5/23/25.
//

import notify
import UIKit

class ViewController: UIViewController {
    
    let notificationName = "com.example.myNotification"
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = " "
        
        registerDispatch_Observe_GetState_Perform { [weak self] str in
            self?.label.text = str ?? "Recieved notification"
        }
        
        registerCheck_GetState_Perform { [weak self] str in
            self?.label.text = str ?? "Recieved notification"
        }
    }
    
    /*
     1. Register with `notify_register_dispatch` and observe in its callback
     2. In the callback
         a. Get state with `notify_get_state`
         b. Perform the passed closure
     3. Even otherwise, right after
         a. Get state with `notify_get_state`
         b. Perform the passed closure
     */
    func registerDispatch_Observe_GetState_Perform(perform: @escaping (String?) -> Void) {
        var notificationRegistrationID: Int32 = 0
        
        let notificationRegistrationResult = notificationName.withCString {
            notify_register_dispatch($0, &notificationRegistrationID, DispatchQueue.main) { _ in
                var notificationAssociatedData: UInt64 = 0
                let getNotificationAssociatedDataResult: UInt32 = notify_get_state(notificationRegistrationID, &notificationAssociatedData)
                
                guard notificationAssociatedData != 0 else { return }   // 0 is returned if no state was set, though FWIW state could have been set to 0
                
                print("Get notification data result - \(getNotificationAssociatedDataResult), Data - \(notificationAssociatedData))")
                perform("From observer - \(String(notificationAssociatedData))")
            }
        }

        guard notificationRegistrationResult == 0 else {
            print("Failed to register using notify_register_dispatch: \(notificationRegistrationResult)")
            return
        }
        print("Registered for Darwin notification using notify_register_dispatch: \(notificationName)")
    }
    
    /*
     1. Register with `notify_register_check`
     2. Get state with `notify_get_state`
     3. Perform the passed closure
     */
    func registerCheck_GetState_Perform(perform: @escaping (String?) -> Void) {
         var notificationRegistrationID: Int32 = 0
        
        let notificationRegistrationResult: UInt32 = notificationName.withCString {
            notify_register_check($0, &notificationRegistrationID)
        }

        print("notificationRegistrationID - \(notificationRegistrationID)")
        guard notificationRegistrationResult == 0 else {
            print("Failed to register using notify_register_check: \(notificationRegistrationResult)")
            return
        }
        print("Registered for Darwin notification using notify_register_check: \(notificationName)")
        
        var notificationAssociatedData: UInt64 = 0
        let getNotificationAssociatedDataResult = notify_get_state(notificationRegistrationID, &notificationAssociatedData)
        
        print("Get notification data result - \(getNotificationAssociatedDataResult))")
        
        guard notificationAssociatedData != 0 else { return }   // 0 is returned if no state was set, though FWIW state could have been set to 0

        print("Get notification data result - \(getNotificationAssociatedDataResult), Data - \(notificationAssociatedData))")
        perform("Without observer - \(String(notificationAssociatedData))")
    }
    
    @IBAction func buttonATapped(_ sender: Any) {
        label.text = " "
    }
    
    @IBAction func buttonBTapped(_ sender: Any) {
        registerCheck_GetState_Perform { [weak self] str in
            self?.label.text = str ?? "Recieved notification"
        }
    }
}
