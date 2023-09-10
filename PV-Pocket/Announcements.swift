//
//  Announcements.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 12/5/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI


//MARK: AnnouncementsList
//Creates all the display elements for the announcements on the home page
struct AnnouncementsList : View {
    @State var showContent = false
    @State var announcements = (UIApplication.shared.delegate as! AppDelegate).announcements
    
    let colors = ["background3", "background4", "background5", "background6", "background7", "background8", "background9", "background10", "background11", "background"]
    // let tags = [] -- will be a dictionary
    let images = ["ALL STUDENTS": "stock1",
                  "SENIOR": "seniorthing",
                  "JUNIOR": "stock4",
                  "SOPHOMORE": "stock4",
                  "FRESHMEN": "stock4",
                  "SPORTS": "stock2",
                  "CLUBS": "stock3"]
    
    var body: some View {
        ZStack {
            if !self.announcements.isEmpty{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 30) {
                        ForEach(0..<self.announcements.count) { i in
                            AnnouncementView(title: "\(Array(self.announcements)[i].key) \nANNOUNCEMENTS", image: self.images["\(Array(self.announcements)[i].key)"]!, color: self.colors[i%10], shadowColor: "background3", announcementText: "\(Array(self.announcements.values)[i].joined(separator: "\n\n"))", announcementImage: "pad22finalsf")
                        }
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                }
            }
            else{
                Button("Refresh") {
                    self.announcements = (UIApplication.shared.delegate as! AppDelegate).announcements
                    print(self.announcements)
                }
            }
        }
    }
}


//MARK: AnnouncementView
//Creates the template for announcement views and allows them to be clickable
struct AnnouncementView : View {
@State var showContent = false
    //Input Variables
    var title: String
    var image: String
    var color: String
    var shadowColor : String
    var announcementText: String
    var announcementImage: String
    
var body: some View {
        HStack(spacing: 30) {
                Button(action: { self.showContent.toggle() }) {
                    VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(20)
                        .lineLimit(2)
                        .padding(.trailing, 50)
                    Spacer()
                    Image(image)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 246, height: 150)
                        .padding(.bottom, 80)
                    }
                    .background(Color(color))
                    .cornerRadius(30)
                    .frame(width: UIScreen.main.bounds.width / 1.6, height: UIScreen.main.bounds.height / 2.2)
                    .shadow(color: Color(shadowColor), radius: 0, x: 0, y: 0)
                        .sheet(isPresented: self.$showContent)
                        {
                            AnnouncementsPopUp(announcement: self.announcementText, image: self.announcementImage, color: self.color)
                            .edgesIgnoringSafeArea(.all)
                        }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }

//MARK: AnnouncementsPopUp
//Template for showing more information when an annoucement is clicked
struct AnnouncementsPopUp: View {
    var announcement: String
    var image: String
    var color: String
        var body: some View {
            VStack {
                Image(image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 150)
            VStack {
                Rectangle()
                    .frame(width: 60, height: 6)
                    .cornerRadius(3.0)
                    .opacity(0.1)
                    .padding(.top, 16)
                VStack {
                    Text(announcement)
                        .lineLimit(100)
                        .padding(20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    Spacer()
                }
            }
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(30)
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 0)
                }
                .background(Color(color))
                .edgesIgnoringSafeArea(.all)
    }
}
