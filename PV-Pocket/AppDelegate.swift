import UIKit
import CoreData
import GoogleSignIn
import CloudKit
import UserNotifications
import PushNotifications
import AVFoundation
import SystemConfiguration

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate {
    
    // Array for storing Courses and Assignments
    public var classes: [Course: [Assignment]] = [:]
    public var announcements: [String: [String]] = [:]
    
    // Bool to check if there is present internet connection
    public var internetConnection: Bool = false;

    public var userLogged = false
    //Accessing our enviornmental variables in AppDelegate
    var settings: UserSettings!
    
    //Create push notifications
    let pushNotifications = PushNotifications.shared
    
    //Attempt to load classes from Classroom if the user is signed in
    func loadClasses() {
        if (GIDSignIn.sharedInstance()?.currentUser != nil) {
            getClasses((GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken!)!, callback: {result in
                self.classes = result;
            })
            getAnnouncements(callback: {result in
                 self.announcements = result;
            })
        }
    }
    
    public func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    internetConnection = CheckConnection()
    //userSettings.set(true, forKey: "DidScan")

    if internetConnection {
      // Initialize sign-in
      GIDSignIn.sharedInstance().clientID = "81815951840-j6aundtijoufj3ssqqksu7priqauigct.apps.googleusercontent.com"
      GIDSignIn.sharedInstance().delegate = self
    
      // Attempt to sign the user in if they previously signed in
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
      //Start listening for push notifications and register to the Pusher database to recieve notifications
      self.pushNotifications.start(instanceId: "72db73d7-9ef9-45a7-a1d9-82a142cf3ea3")
      self.pushNotifications.registerForRemoteNotifications()
      try? self.pushNotifications.addDeviceInterest(interest: "debug-test")
      try? self.pushNotifications.addDeviceInterest(interest: "test")
        
    }
    
      //Set all of the user's wanted interests to recieve only wanted notfications
      //for string in settings.announcementInterests {
      //    try? self.pushNotifications.addDeviceInterest(interest: string)
      //  }
        
      UINavigationBar.appearance().backgroundColor = .clear
        
      return true
    }
    
    //GIDSignIn code to allow for signing in with Google
    public func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //More GIDSignIn code to allow for signing in with Google
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
            withError error: Error!) {
    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
    }
    loadClasses()
    
//    GIDGivenName = (GIDSignIn.sharedInstance()?.currentUser.profile.givenName)!

}
    
    //Prompts the user asking if they want to allow push notfications
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      self.pushNotifications.registerDeviceToken(deviceToken)
    }

    //Handle push notifications when one is recieved
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
    }
    // MARK: UISceneSession Lifecycle

    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SwiftUI_Test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
