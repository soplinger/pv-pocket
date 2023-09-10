//
//  DigitalIDView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 1/22/20.
//  Copyright © 2020 Sean Oplinger. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import URLImage

//MARK: DigitalID
//View that is shown when the profile button is tapped
struct DigitalID: View {
    
    @EnvironmentObject var settings: UserSettings
        
    @ViewBuilder var body: some View {
        if userSettings.string(forKey: "UserID") == nil {
            DigitalIDCreate()
        }
        else {
            DigitalIDCreated()
        }
    }
}

struct DigitalIDCreated: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack {
            TitleView(viewTitle: "Digital ID")
            UserCard()
                .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 1.3)
            IDView(barcode: generateBarcode(from: "\(userSettings.string(forKey: "UserID")!)")!, category: "Digital ID", heading: "Here is your ID, \((GIDSignIn.sharedInstance()?.currentUser.profile.givenName)!)")
                .foregroundColor(.white)
                .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 1.25)
        }
    }
}

struct DigitalIDCreate: View {
   
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack {
            TitleView(viewTitle: "Digital ID")
            VStack {
                Text("Your Digital ID has not yet been created")
                .font(.headline)
                .padding(.bottom, 10)
                Button(action: { self.settings.restartScan.toggle() }) {
            Text("Tap here if you want to create your Digital ID")
                }
            }
            .offset(y: UIScreen.main.bounds.height + -UIScreen.main.bounds.height * 1.5)
        }
    }
}

struct UserCard : View {
    
    var profilePicture = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 200)
    var body: some View {
        return VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text((GIDSignIn.sharedInstance()?.currentUser.profile.name)!)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 5)
                        .frame(width: 340, alignment: .center)
                    /*Button(action: {UIApplication.shared.open(URL(string: "mailto:\(self.teacher.emailAddress)")!)})
                    {
                        URLImage(URL(string: "https:" + teacher.photoURL)!, placeholder: Image("teacherpicturetemp")) {
                            proxy in
                                proxy.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                        }
                            .frame(width: UIScreen.main.bounds.width * 0.7 , height: UIScreen.main.bounds.height / 5)
                            //.cornerRadius(150)
                            //.clipped()
                            .padding(.top, 7.5)
                            .offset(x: UIScreen.main.bounds.width + -UIScreen.main.bounds.width * 0.935)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }*/
                    URLImage(profilePicture!, placeholder: Image("teacherpicturetemp")) {
                            proxy in
                                proxy.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                    }
                        .frame(width: UIScreen.main.bounds.width * 0.7 , height: UIScreen.main.bounds.height / 5)
                        //.cornerRadius(150)
                        //.clipped()
                        .padding(.top, 7.5)
                        .offset(x: UIScreen.main.bounds.width + -UIScreen.main.bounds.width * 0.935)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()
            }
        .frame(width: UIScreen.main.bounds.width * 0.9 , height: UIScreen.main.bounds.height / 3.5)
            .background(Color("icons"))
            .cornerRadius(10)
            .shadow(radius: 20)
    }
}
