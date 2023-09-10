//
//  Login.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 12/3/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct Login: View {

    @EnvironmentObject var settings: UserSettings
    
    @ViewBuilder var body : some View {
        if  !settings.hasInternet {
            NoInternet()
        }
        else if GIDSignIn.sharedInstance()?.currentUser != nil || settings.isLoggedB {
            MainView()
        }
        else {
            LoginPage()
        }
    }
}


struct LoginPage: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        //Login Page
        NavigationView {
                ScrollView {
                        VStack {
                    VLargeCardView(image: "pad22finalsf", category: "Login", heading: "Welcome to PV Pocket!", author: "PAD22")
                    //Google Sign In Button
                    google()
                        .frame(width: 200, height: 50)
                    
                    //Switch to main view after login
                    NavigationLink(destination: MainView(), isActive: $settings.isLoggedB) {
                        ZStack {
                           Rectangle()
                                .frame(width: 300, height: 50)
                                .cornerRadius(5)
                                .foregroundColor(Color(.systemGray))
                           Text("Click here after sign in")
                                .foregroundColor(.primary)
                                .font(Font.system(size: 25))
                            }
                        }
                        .navigationBarHidden(true) .navigationBarTitle("")
                    }
                }
            }
        }
    }
            
struct NoInternet: View {
    
    @State var viewState = CGSize.zero
    
    var body: some View {
        VStack {
        TitleView(viewTitle: "No Internet Connection")
            VStack {
                Image("pvsdlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .padding(.top, 5)
                Text("PV Pocket requires an active internet connection to launch.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: 350, height: 50, alignment: .center)
                Text("Please check your connection and try again.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: 350, height: 50, alignment: .center)
            }
            .offset(x: viewState.width, y: viewState.height - 300)
        }
    }
}

//Creates Google Sign In instance
struct google : UIViewRepresentable {
    
    @EnvironmentObject var settings: UserSettings

    func makeUIView(context: UIViewRepresentableContext<google>) -> GIDSignInButton {
        
        //Create Google Sign In Button
        let button = GIDSignInButton()
        button.colorScheme = .dark
        button.style = .wide
            
        //Add Scopes to Login
        
        // Used for reading user's Classroom courses
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/classroom.courses.readonly")
        // Used for reading the coursework in a user's course
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/classroom.coursework.me.readonly")
        // Used for reading the teacher of a Classroom course
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/classroom.rosters.readonly")
        // Used for retrieving the teacher's email
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/classroom.profile.emails")
        // Used for retrieving a teacher's profile picture
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/classroom.profile.photos")
        
        //Restore Previous Login if it exsists
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        //idk what this does but we need it
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            
        return button
        
    }
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<google>) {

    }
}
