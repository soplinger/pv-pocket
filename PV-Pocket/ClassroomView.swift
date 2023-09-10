//
//  ClassroomView.swift
//  Pv-Pocket
//
//  Created by Sean Oplinger on 11/23/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import URLImage

//MARK: ClassroomView
//Creates the UI Front-end for the whole view
struct ClassroomView: View {
    
    @EnvironmentObject var settings: UserSettings
    @State var showContent = false
    
    //Access classes that were pulled from Google
    let classes = (UIApplication.shared.delegate as! AppDelegate).classes
    //URL to take the user to Home Access Center
    let url = URL(string: "https://hac.pvsd.org/homeaccess")!
    
    var body: some View {
        NavigationView {
                ScrollView {
                        VStack {
                            Button(action: { UIApplication.shared.open(self.url) } ) {
                                VLargeCardView(image: "pad22finalsf", category: "PV Classroom", heading: "Click here to go to Home Access", author: "PAD22")
                                }
                                .buttonStyle(PlainButtonStyle())
                                Classes()
                            }
                        }
                        .frame(minHeight: 0, maxHeight: .infinity)
                        .navigationBarTitle("PV Classroom")
                    }
                    .background(Color.primary)
                }
            }

//MARK: Classes
//Takes all the classes pulled from Google and turns them into UI Elements that the user can interact with
struct Classes: View {
    
    let classes = (UIApplication.shared.delegate as! AppDelegate).classes
    
    @ViewBuilder var body: some View {
        ForEach(0..<classes.count) { i in
            ClassCard(banner: "pad22finalsf", className: "\(Array(self.classes)[i].key.name)", room: Array(self.classes)[i].key.room != "" ? "Room " + Array(self.classes)[i].key.room : "", teacher: Array(self.classes)[i].key.teacher, assignments: Array(self.classes.values)[i])
        }
    }
}

//MARK: ClassCard
//Template used for displaying all of the users current classes
struct ClassCard: View {
    
    @State var classShow = false
    
    var banner: String
    var className: String
    var room: String
    var teacher: Person
    var assignments: [Assignment]
            
        var body: some View {
            Button(action: { self.classShow.toggle() }) {
            ZStack {
                VStack {
                    Image(banner)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(teacher.firstName + " " + teacher.lastName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(className)
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Text(room)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .layoutPriority(100)
         
                        Spacer()
                    }
                    .padding()
                }
                .background(Color(.systemOrange))
                .cornerRadius(30)
                .padding([.top, .horizontal])
                .sheet(isPresented: self.$classShow)
                {
                    ClassDetail(assignments: self.assignments, teacher: self.teacher, className: self.className, room: self.room)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//MARK: Class Detail
//Template used for displaying all of the class information after the user taps on any one of their classes
struct ClassDetail: View {
    
    var assignments: [Assignment]
    var teacher: Person
    var className: String
    var room: String

    var body: some View {
        ZStack {
            //BlurView(style: .systemMaterial)
            ScrollView {
                VStack {
                    VStack {
                        Rectangle()
                            .frame(width: 60, height: 6)
                            .cornerRadius(3.0)
                            .opacity(0.1)
                            .padding(.top, 20)
                        VStack {
                            TitleView(viewTitle: className)
                            DetailCard(teacher: teacher)
                            TitleView(viewTitle: "Assignments")
                            ForEach(0..<assignments.count) { i in
                                Text("\(self.assignments[i].title) - (\(self.assignments[i].points) Points)")
                                    //.lineLimit(100)
                                    .padding(15)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        UIApplication.shared.open(URL(string: self.assignments[i].url)!)
                                    }
                        }
                    
                        }
                    }
                    .cornerRadius(30)
                }
                .frame(minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//MARK: DetailCard
//Creates the teacher profile card in the classroom view
struct DetailCard : View {
    
    var teacher: Person
    
    var body: some View {
        return VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(teacher.firstName + " " + teacher.lastName)
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
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "mailto:\(self.teacher.emailAddress)")!)
                        }
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
