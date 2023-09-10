//
//  SplashScreen.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 1/23/20.
//  Copyright © 2020 Sean Oplinger. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        ZStack {
            BlurView(style: .systemMaterial)
            ScrollView {
                VStack(alignment: .center)   {

                       Spacer()

                       TitleViewSplash()

                       InformationContainerView()

                       Spacer(minLength: 30)

                       Button(action: {
                           userSettings.set("seen", forKey: "sawSplash")
                           self.settings.clearSplash = true
                       }) {
                           Text("Continue")
                               .foregroundColor(.white)
                               .font(.headline)
                               .padding()
                               .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                               .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                               .fill(Color(UIColor.systemOrange)))
                               .padding(.bottom)
                       }
                       .padding(.horizontal)
                   }
               }
               .offset(y: UIScreen.main.bounds.height + -UIScreen.main.bounds.height * 1.0125)
        }
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.mainColor)
                .padding()
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Announcements", subTitle: "Access PVHS announcements from the homepage of the app to recieve all current information", imageName: "tray")

            InformationDetailView(title: "Classroom", subTitle: "Get a quick glance at all of your classes and due assignments", imageName: "book")

            InformationDetailView(title: "Digital ID", subTitle: "A Digital ID that can be used at the library", imageName: "person.crop.rectangle")
            
            InformationDetailView(title: "Lunch", subTitle: "See what the cafeteria has to offer and order a sandwich from the deli", imageName: "bag")
            
            InformationDetailView(title: "Map", subTitle: "Access the PVHS map to map the best routes between classes", imageName: "map")
        }
        .padding(.horizontal)
    }
}

struct TitleViewSplash: View {
    var body: some View {
        VStack {
            Image("Pad-22LOGO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, alignment: .center)
                .accessibility(hidden: true)

            Text("Welcome to")
                .customTitleText()

            Text("PV Pocket")
                .customTitleText()
                .foregroundColor(.mainColor)
        }
    }
}

extension Text {
    func customTitleText() -> Text {
        self
            .fontWeight(.black)
            .font(.system(size: 36))
    }
}

extension Color {
    static var mainColor = Color(UIColor.systemOrange)
}
