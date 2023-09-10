//
//  UserSettings.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 12/10/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import Foundation
import GoogleSignIn
import CoreNFC

//MARK: UserSettings
//Creates variables that can be changed and accessed anywhere throughout the app
class UserSettings: ObservableObject {
    @Published var givenName = ""
    @Published var profileView = false
    @Published var studentID = userSettings.string(forKey: "UserID")
    @Published var restartScan = false
    @Published var sawSplash = userSettings.string(forKey: "sawSplash")
    @Published var clearSplash = false
    @Published var sawSurvey = userSettings.string(forKey: "sawSurvey")
    @Published var clearSurvey = false
    @Published var gradeLevel = userSettings.string(forKey: "gradeLevel")
    @Published var isLoggedS = GIDSignIn.sharedInstance()?.currentUser
    @Published var isLoggedB = false
    @Published var hasSignedIn = false
    @Published var didPressSignOut = false
    @Published var didShowClasses = false
    @Published var announcementInterests = [String]()
    @Published var hasInternet = (UIApplication.shared.delegate as! AppDelegate).internetConnection
    @Published var screenWidth = UIScreen.main.bounds.width
    @Published var screenHeight = UIScreen.main.bounds.width
    @Published var showProfile = false
    @Published var showSettings = false

}

let userSettings: UserDefaults = UserDefaults.standard


//MARK: UserData
//Class used for NFC reading
final class NFCData: UITableViewController, ObservableObject, NFCTagReaderSessionDelegate {

        func startScan() {
            let readerSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
            readerSession?.alertMessage = "Hold your iPhone near a classroom card."
            readerSession?.begin()
        }

        func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
            // If necessary, you may perform additional operations on session start.
            // At this point RF polling is enabled.
            print("active")
        }

        func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
            // If necessary, you may handle the error. Note session is no longer valid.
            // You must create a new session to restart RF polling.
        }

        func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
            if tags.count > 1 {
                print("More than 1 tag was found. Please present only 1 tag.")
                session.invalidate(errorMessage: "More than 1 tag was found. Please present only 1 tag.")
                return
            }

            guard let firstTag = tags.first else {
                print("Unable to get first tag")
                session.invalidate(errorMessage: "Unable to get first tag")
                return
            }

            print("Got a tag!", firstTag)
        }
    
    }

/*final class UserData: ObservableObject {

    @Published var studentID: String? {
        didSet {
            UserDefaults.standard.set(_studentID, forKey: "studentID")
        }
    }

    init() {
        self.studentID = UserDefaults.standard.string(forKey: "userName")
    }

}
*/
