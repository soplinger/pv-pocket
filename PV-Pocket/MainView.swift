//
//
//  ContentView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 11/22/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import AVFoundation
import CoreNFC
import CoreData

let coloredNavAppearance = UINavigationBarAppearance()

//MARK: MainView
//View housing all other views
struct MainView: View {
    
    @EnvironmentObject var settings: UserSettings
    @State var show = false
    
    var body: some View {
    
        ZStack {
            
            MainTabView()
            .scaleEffect(settings.restartScan ? 0.95 : 1)
            .scaleEffect(settings.showSettings ? 0.95 : 1)
            .blur(radius: settings.restartScan ? 20 : 0)
            .blur(radius: settings.showSettings ? 20 : 0)
            .animation(.spring())
            .edgesIgnoringSafeArea(.top)
            
            SettingsView()
            .cornerRadius(30)
            .shadow(radius: 20)
            .animation(.spring())
            .offset(y: settings.showSettings ? UIScreen.main.bounds.height / 3 : UIScreen.main.bounds.height)
            .onTapGesture {
                self.settings.showSettings = false
            }
            
            if settings.restartScan {
            StartupView()
            .cornerRadius(30)
            .shadow(radius: 20)
            .animation(.spring())
            .offset(y: settings.restartScan ? UIScreen.main.bounds.height / 10 : UIScreen.main.bounds.height)
            }
            
            if settings.sawSplash == nil && !settings.clearSplash {
            SplashScreen()
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
            }
            
            if settings.sawSurvey == nil && !settings.clearSurvey {
            StartSurvey()
            .animation(.spring())
            }
            
        }
    }
}

//MARK: MainTabView
struct MainTabView: View {
    var body: some View {
        //Create Tab View
        TabView {
            
            //Add HomeView Button to Tab View
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
            }.tag(1)
            
            //Add ClassroomView Button to Tab View
            ClassroomView()
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                        Text("Classroom")
                    }
            }.tag(2)
            
            //Add DigitalID Button to Tab View
            DigitalID()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.rectangle")
                        Text("Student ID")
                    }
            }.tag(3)
            
            //Add LunchView Button to Tab View
            LunchView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag")
                        Text("Lunch")
                    }
            }.tag(4)
           
            //Add MapView Button to Tab View
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Map")
                    }
            }.tag(5)
        }
    }
}

//MARK: StartupView
struct StartupView: View {

@EnvironmentObject var settings: UserSettings

var body: some View {
    ZStack {
        BlurView(style: .systemMaterial)
            VStack {
                TitleView(viewTitle: "Setup")
                Text("Please find your student ID and place the barcode inside of the box below")
                .padding([.leading, .trailing], 10)
                .offset(y: UIScreen.main.bounds.height + -UIScreen.main.bounds.height * 1.5)
                BarcodeScanner(supportBarcode: [.code128, .code39, .code93, .code39Mod43]) 
                .interval(delay: 5.0) //Event will trigger every 5 seconds
                .found {
                    userSettings.set($0, forKey: "UserID")
                    self.settings.restartScan = false
                    print($0)
                    }
                .cornerRadius(30)
                .frame(width: UIScreen.main.bounds.width / 1.25, height: UIScreen.main.bounds.height / 4)
                .offset(y: UIScreen.main.bounds.height + -UIScreen.main.bounds.height * 1.48)
                Button(action: { self.settings.restartScan = false }) {
                    Text("Tap here to cancel Digital ID Setup")
                }
                .offset(y: UIScreen.main.bounds.height + -UIScreen.main.bounds.height * 1.15)
                }
            }
        }
    }

//MARK: PassCreation
//View for the pass creation
struct PassCreation: View {
    
    @EnvironmentObject var userData: NFCData

    var body: some View {
        
        ZStack {
                //Cleans up background
                BlurView(style: .systemMaterial)
                    //Creates the title of the view
                    TitleView(viewTitle: "Pass Creator")
                        Button(action: { self.userData.startScan() }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 300, height: 50)
                                    .cornerRadius(5)
                                    .foregroundColor(Color(.systemGray))
                                Text("I'm Leaving Now!")
                                    .foregroundColor(.primary)
                                    }
                                }
                                .offset(y: 225)
            
                            BottomView(bottomText: "Create a Pass to go anywhere in the buiding with teacher permission")
                            .offset(y: 100)
            
                            }
                        }
                    }

//MARK: SettingsView
//View that is shown when the settings button is tapped
struct SettingsView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    @State var viewState = CGSize.zero
    @State var showDebug = false
    
    var body: some View {
            ZStack {
            BlurView(style: .systemMaterial)
                VStack {
                  TitleView(viewTitle: "Settings")
                    Button(action: { self.showDebug.toggle() }) {
                     ZStack {
                       Rectangle()
                             .frame(width: 300, height: 50)
                             .cornerRadius(15)
                        .foregroundColor(Color(.systemGray))
                         Text("Debug Information")
                            .foregroundColor(.primary)
                            .font(Font.system(size: 25))
                            .sheet(isPresented: self.$showDebug)
                            {
                                DebugView()
                            }
                         }
                    }
                    .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 2.7)
                    Spacer()
                    Button(action: {
                        GIDSignIn.sharedInstance()!.signOut()
                        self.settings.didPressSignOut = true
                        self.settings.showSettings = false
                    }) {
                        ZStack {
                            Rectangle()
                                 .frame(width: 300, height: 50)
                                 .cornerRadius(15)
                                 .foregroundColor(Color(.systemGray))
                            Text("Sign Out")
                                 .foregroundColor(.primary)
                                 .font(Font.system(size: 25))
                         }
                    }
                    .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 2.675)
                    
                    Button(action: {
                        self.settings.sawSplash = nil
                        self.settings.clearSplash = false
                    }) {
                        ZStack {
                            Rectangle()
                                 .frame(width: 300, height: 50)
                                 .cornerRadius(15)
                                 .foregroundColor(Color(.systemGray))
                            Text("Show Welcome Page")
                                 .foregroundColor(.primary)
                                 .font(Font.system(size: 25))
                         }
                    }
                    .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 2.65)

                    
                    Text("Tap to dismiss")
                        .foregroundColor(.gray)
                        .offset(y: -UIScreen.main.bounds.height + UIScreen.main.bounds.height / 1.5)
                }
            }
        }
    }

//MARK: DebugView
//View containing some debug information
struct DebugView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("User Access Token: \((GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken)!)")
                }
                Section {
                    Text("User Client ID: \((GIDSignIn.sharedInstance()?.currentUser.authentication.clientID)!)")
                }
                Section {
                    Text("User Email: \((GIDSignIn.sharedInstance()?.currentUser.profile.email)!)")
                }
                Section {
                    Text("User Name: \((GIDSignIn.sharedInstance()?.currentUser.profile.name)!)")
                }
                Section {
                    Text("User ID: \((GIDSignIn.sharedInstance()?.currentUser.userID)!)")
                }
                .navigationBarTitle("Debug")
            }
        }
    }
}

//MARK: IDView
//Shown on the profile page
//Creates the users ID and displays it
struct IDView: View {
    
    var barcode: UIImage
    var category: String
    var heading: String
    
    var body: some View {
        VStack {
            Image(uiImage: barcode)
                .resizable()
                .aspectRatio(contentMode: .fit)
 
            HStack {
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(heading)
                 //       .font(.system(size: 20))
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                .layoutPriority(100)
 
                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

//MARK: generateBarcode
//Creates a barcode from a string when called
func generateBarcode(from string: String) -> UIImage? {

    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setDefaults()
        //Margin
        filter.setValue(7.00, forKey: "inputQuietSpace")
        filter.setValue(data, forKey: "inputMessage")
        //Scaling
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
            let rawImage:UIImage = UIImage.init(cgImage: cgImage)

            let cgimage: CGImage = (rawImage.cgImage)!
            let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
            let cWidth: size_t  = size_t(cropZone.size.width)
            let cHeight: size_t  = size_t(cropZone.size.height)
            let bitsPerComponent: size_t = cgimage.bitsPerComponent
            //THE OPERATIONS ORDER COULD BE FLIPPED, ALTHOUGH, IT DOESN'T AFFECT THE RESULT
            let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)

            let context2: CGContext = CGContext(data: nil, width: cWidth, height: cHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!

            context2.draw(cgimage, in: cropZone)

            let result: CGImage  = context2.makeImage()!
            let finalImage = UIImage(cgImage: result)

            return finalImage

        }
    }

    return nil
}

//MARK: MenuRight
struct MenuRight : View {
    
    @Binding var showProfile : Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        return VStack {
            HStack(spacing: 12) {
                Spacer()
                Button(action: { self.showSettings.toggle() }) {
                    CircleButton(icon: "gear")
                }
            }
            Spacer()
        }
    }
}

//MARK: CircleButton
struct CircleButton : View {
    var icon = "person.crop.circle"
    var body: some View {
        return HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
        }
        .frame(width: 44, height: 44)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 10, x: 0, y: 10)
}
}


//MARK: StartSurvey
struct StartSurvey: View {
    
    @EnvironmentObject var settings: UserSettings
    
    var gradeLevel = ["9th Grade", "10th Grade", "11th Grade", "12th Grade", "Teacher"]
    var classroomDates = ["1 Week", "2 Weeks", "3 Weeks", "1 Month", "All"]

    @State private var selectedGradeLevel = 0
    @State private var selectedClassroomDate = 0
    @State private var enableSports = false
    @State private var enableClubs = false

    var pushNotifications = (UIApplication.shared.delegate as! AppDelegate).pushNotifications
    
    var body : some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Grade Level")) {
                    Picker(selection: $selectedGradeLevel, label: Text("Grade")) {
                        ForEach(0 ..< gradeLevel.count) {
                            Text(self.gradeLevel[$0])

                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Announcements Settings")){
                
                    Toggle(isOn: $enableSports) {
                        Text("Sports Announcements")
                        }
                    Toggle(isOn: $enableClubs) {
                        Text("Club Annoucements")
                        }
                }
                
                Section(header: Text("Classroom Settings")) {
                    Picker(selection: $selectedClassroomDate, label: Text("How far back do you want your assignments to go?")) {
                        ForEach(0 ..< classroomDates.count) {
                            Text(self.classroomDates[$0])

                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button(action: {
                    userSettings.set("seen", forKey: "sawSurvey")
                    if self.enableSports {
                        userSettings.set("debug-sports", forKey: "enableSports")
                        try? self.pushNotifications.addDeviceInterest(interest: userSettings.string(forKey: "enableSports")!)
                    }
                    else {
                        userSettings.set("nil", forKey:"enableSports")
                    }
                    
                    if self.enableClubs {
                        userSettings.set("debug-clubs", forKey:"enableClubs")
                        try? self.pushNotifications.addDeviceInterest(interest: userSettings.string(forKey: "enableClubs")!)
                    }
                    else {
                        userSettings.set("nil", forKey: "enableClubs")
                    }
                    
                    if self.selectedGradeLevel == 4 {
                        userSettings.set("teacher", forKey: "gradeLevel")
                        try? self.pushNotifications.addDeviceInterest(interest: "debug-senior")
                    }
                    
                    else if self.selectedGradeLevel == 3 {
                        userSettings.set("senior", forKey: "gradeLevel")
                        try? self.pushNotifications.addDeviceInterest(interest: "debug-senior")
                    }
                    
                    else if self.selectedGradeLevel == 2 {
                        userSettings.set("junior", forKey: "gradeLevel")
                        try? self.pushNotifications.addDeviceInterest(interest: "debug-junior")
                    }
                    
                    else if self.selectedGradeLevel == 1 {
                        userSettings.set("sophmore", forKey: "gradeLevel")
                        try? self.pushNotifications.addDeviceInterest(interest: "debug-sophmore")
                    }
                    
                    else if self.selectedGradeLevel == 0 {
                        userSettings.set("freshman", forKey: "gradeLevel")
                        try? self.pushNotifications.addDeviceInterest(interest: "debug-freshman")
                    }
                    
                    if self.selectedClassroomDate == 4 {
                        userSettings.set("all", forKey: "assignmentDates")
                    }
                    
                    else if self.selectedClassroomDate == 3 {
                        userSettings.set("month", forKey: "assignmentDates")
                    }
                    
                    else if self.selectedClassroomDate == 2 {
                        userSettings.set("threeWeek", forKey: "assignmentDates")
                    }
                    
                    else if self.selectedClassroomDate == 1 {
                        userSettings.set("twoWeek", forKey: "assignmentDates")
                    }
                    
                    else if self.selectedClassroomDate == 0 {
                        userSettings.set("oneWeek", forKey: "assignmentDates")
                    }
                    
                    //userSettings.set("debug-\(self.gradeLevel)", forKey: "gradeLevel")
                    //try? self.pushNotifications.addDeviceInterest(interest: userSettings.string(forKey: "gradeLevel")!)
                    
                    self.settings.clearSurvey = true }) {
                    Text("Done")
                }
                
            }.navigationBarTitle(Text("Preferences"))
        }
        
    }
}

//MARK: ActivityIndicator
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//MARK: LoadingView
struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
