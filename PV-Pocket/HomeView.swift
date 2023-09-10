//
//  HomeView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 11/23/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct HomeView : View {
    
    @EnvironmentObject var settings: UserSettings
    //Create State Variables
    @State var show = false
    @State var screenHeight = UIScreen.main.bounds.height
    
    var body : some View {
        ZStack {
            TitleView(viewTitle: "Welcome, \((GIDSignIn.sharedInstance()?.currentUser.profile.givenName)!)!")
                .offset(y: self.screenHeight - self.screenHeight * 1.001 )
                                
            //Houses ID Card
            WelcomeCard(cardTitle: "Welcome to PV Pocket!", cardLetterDay: "It is an A Day", schedule: "December 10 6:00 – 7:00pm\nPVSD Wellness Committee Meeting")
            .offset(y: self.screenHeight - self.screenHeight * 1.2125)
        
            //Shows Announcements
            AnnouncementsList()
                .offset(y: self.screenHeight / 6)
                
            MenuRight(showProfile: $settings.showProfile, showSettings: $settings.showSettings)
                .offset(x: -10, y: settings.showProfile ? 0 : 5)
                .offset(x: -10, y: settings.showSettings ? 0 : 5)
                .animation(.spring())
                    
            }
        }
    }

struct HomeViewID: View {
    
    @EnvironmentObject var settings: UserSettings
    @State var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
                //Cleans up background
                //BlurView(style: .systemMaterial)
                            //Creates the title of the view
                TitleView(viewTitle: "Welcome, \((GIDSignIn.sharedInstance()?.currentUser.profile.givenName)!)!")
                                .offset(y: self.screenHeight - self.screenHeight * 1.001 )
                                
                            //Houses ID Card
                            WelcomeCard(cardTitle: "Welcome to PV Pocket!", cardLetterDay: "It is an A Day", schedule: "December 10 6:00 – 7:00pm\nPVSD Wellness Committee Meeting")
                                .offset(y: self.screenHeight - self.screenHeight * 1.2125)
        
                            //Shows Announcements
                            AnnouncementsList()
                                .offset(y: self.screenHeight / 6)
                
                            MenuRight(showProfile: $settings.showProfile, showSettings: $settings.showSettings)
                                .offset(x: -10, y: settings.showProfile ? 0 : 5)
                                .offset(x: -10, y: settings.showSettings ? 0 : 5)
                                .animation(.spring())
                    
                        }
        /*.sheet(isPresented: self.$settings.didScan)
        {
            HomeViewIDCapture()
                .environmentObject(self.settings)
        }*/
    }
}

