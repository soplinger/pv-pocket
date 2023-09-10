//
//  MapView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 11/23/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import UIKit

/*struct MapView: View {
    
    @State var classShow = false
    @State var code = ""
    @State var scanned = false
    
    var body : some View {
       ZStack {
           
        BlurView(style: .systemMaterial)
               TitleView(viewTitle: "PVHS Map")
       
               ScrollView (showsIndicators: false) {
                VLargeCardView(image: "mapsstock", category: "PVHS Map", heading: "Welcome to the map of PVHS!", author:"PAD22")
                   
               }
            .offset(y: 60)
           } .navigationBarHidden(true) . navigationBarTitle("")
        }
    }
*/

struct MapView: View {
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    @State var currentRoom: String = ""
    @State var destinationRoom: String = ""
    
    @State var rooms: [String] = ["006","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","143","144","145","146","147","148","149","150","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","255","256","257","258","259","260","261","262","301","302","303","304","305","306","307","308","309","310","700","701","702","703","710","730","750","800","900","Auditorium","Cafeteria","CC","Conference","Counselor","Fitness Center","Old Gymnasium","New Gymnasium","IPC","ISS","Laboratory","Library","MO","Perkiomen_Valley_Virtual","TechL","UC"]
    
    @State var currentFloor: Image = Image("PVMapFloor1")
    
    //Sets overlay opacity when button is pressed
    @State var button1Opacity: Double = 0.2
    @State var button2Opacity: Double = 0.0
    @State var button3Opacity: Double = 0.0
    
    //Sets button Image when button is pressed
    @State var b1Icon: String = "map.fill"
    @State var b2Icon: String = "map"
    @State var b3Icon: String = "map"
    
    @State private var roomAlert = false
    
    //Binds to MapView and Sends button
    @State var scale: CGFloat = 1
    
    @State var modalDisplayed = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                Divider()
                
                Spacer()
                
                Rectangle()
                .fill(
                    Color.white
                )
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .overlay(
                        MapView(scale: self.$scale, currentFloor: self.$currentFloor)
                        .overlay(
                            VStack() {
                                VStack() {
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.3)) {
                                    if self.scale < 5 {
                                        self.scale += 1
                                    }
                                    }
                                }) {
                                   Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.blue)
                                   .background(Circle()
                                    .fill(
                                        Color.white
                                    )
                                   )
                                   .padding(.bottom, 30)
                                   .padding(.trailing, 15)
                                    }
                                
                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.3)) {
                                    if self.scale > 1 {
                                        self.scale -= 1
                                    }
                                    }
                                }) {
                                   Image(systemName: "minus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(Color.blue)
                                   .background(Circle()
                                    .fill(
                                        Color.white
                                    )
                                   )
                                   .padding(.bottom, 100)
                                   .padding(.trailing, 15)
                                    }
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
                                
                            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
                        )
                        .background(
                            Color.clear
                        )
                        .cornerRadius(20, antialiased: true)
                        
                )
                    .cornerRadius(20, antialiased: true)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                   
                Spacer()
                
                HStack {
                    Button(action: {
                        self.currentFloor = Image("PVMapFloor1")
                        
                        withAnimation(.easeOut(duration: 0.8)) {
                        self.button1Opacity = 0.2
                        self.button2Opacity = 0.0
                        self.button3Opacity = 0.0
                            
                        self.b1Icon = "map.fill"
                        self.b2Icon = "map"
                        self.b3Icon = "map"
                        }
                    }) {
                        HStack {
                            Image(systemName: b1Icon)
                                .foregroundColor(.blue)
                            Text("1")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Rectangle()
                            .fill (
                                Color.secondary
                            )
                            .overlay (
                                Rectangle()
                                    .fill (
                                        Color.secondary.opacity(button1Opacity)
                                    )
                            )
                            .frame(width: 50)
                            .cornerRadius(20)
                            )
                        }
                    Spacer()
                        .frame(width: 40)
                
                Button(action: {
                    self.currentFloor = Image("PVMapFloor2")
                    
                 withAnimation(.easeOut(duration: 0.8)) {
                    self.button1Opacity = 0.0
                    self.button2Opacity = 0.2
                    self.button3Opacity = 0.0
                    
                    self.b1Icon = "map"
                    self.b2Icon = "map.fill"
                    self.b3Icon = "map"
                    }
                }) {
                    HStack {
                        Image(systemName: b2Icon)
                            .foregroundColor(.blue)
                        Text("2")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Rectangle()
                    .fill (
                        Color.secondary
                    )
                        .overlay (
                            Rectangle()
                                .fill (
                                    Color.secondary.opacity(button2Opacity)
                                )
                        )
                        .frame(width: 50)
                        .cornerRadius(20)
                        )
                    }
                    Spacer()
                        .frame(width: 40)
                    
                    Button(action: {
                            self.currentFloor = Image("PVMapFloor3")
                        
                        withAnimation(.easeOut(duration: 0.8)) {
                            self.button1Opacity = 0.0
                            self.button2Opacity = 0.0
                            self.button3Opacity = 0.2
                            
                            self.b1Icon = "map"
                            self.b2Icon = "map"
                            self.b3Icon = "map.fill"
                        }
                    }) {
                        HStack {
                            Image(systemName: b3Icon)
                                .foregroundColor(.blue)
                            Text("3")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Rectangle()
                        .fill (
                            Color.secondary
                        )
                            .overlay (
                                Rectangle()
                                    .fill (
                                        Color.secondary.opacity(button3Opacity)
                                    )
                            )
                        .frame(width: CGFloat(50))
                            .cornerRadius(20)
                        )
                        }
                }
                
                HStack {
                Button(action: { self.modalDisplayed = true }) {
                    HStack {
                        Text("Highlight Rooms")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(.all, 10)
                    .background(Rectangle()
                        .fill (
                        Color.blue
                    )
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .cornerRadius(20)
                    )
                }.sheet(isPresented: $modalDisplayed, onDismiss: {
                    print("Current Room is valid: \(self.validateRooms(roomP: self.currentRoom, rooms: self.rooms))")
                    print("Destination Room is valid: \(self.validateRooms(roomP: self.destinationRoom, rooms: self.rooms))")
                    
                    let notification = Notification(name: Notification.Name("Hello"))
                    NotificationQueue.default.enqueue(notification, postingStyle: .now, coalesceMask: .none, forModes: nil)
                    
                    if !self.validateRooms(roomP: self.currentRoom, rooms: self.rooms) && !self.currentRoom.isEmpty || !self.validateRooms(roomP: self.destinationRoom, rooms: self.rooms) && !self.destinationRoom.isEmpty {
                        self.currentRoom = ""
                        self.currentRoom = ""
                        self.roomAlert = true
                    }
                    
                    if !self.validateRooms(roomP: self.destinationRoom, rooms: self.rooms) && !self.destinationRoom.isEmpty {
                        
                    }
                    
                }) {
                        SubmittedView(currentRoom: self.$currentRoom, destinationRoom: self.$destinationRoom, rooms: self.$rooms)
                    }
                    
                    .alert(isPresented: $roomAlert) {
                        Alert(title: Text("Error:"), message: Text("please enter a valid current room"), dismissButton: .default(Text("Ok")))
                    }
                    
                    Text("\(self.currentRoom)")
                    
                    Text("\(self.destinationRoom)")
                    
                    
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0, alignment: .center)
                    .padding(.all, 15)
                
                Divider()
                    
            }.background(colorScheme == .light ? Color.white : Color.black)
    }
}
    
    func validateRooms(roomP: String, rooms: [String]) -> Bool {
        var rv: Bool = false
        for room in rooms {
            if roomP == room {
                rv = true
                break
            } else {
                rv = false
            }
        }
        return rv
    }

struct MapView: View {

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}

@GestureState var dragState = DragState.inactive
@State var viewState = CGSize.zero
    
    @Binding var scale: CGFloat
    
    @Binding var currentFloor: Image

var body: some View {
    print(viewState)
let minimumLongPressDuration = 0.0
let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
    .sequenced(before: DragGesture())
    .updating($dragState) { value, state, transaction in
        switch value {
        // Long press begins.
        case .first(true):
            state = .pressing
        // Long press confirmed, dragging may begin.
        case .second(true, let drag):
            state = .dragging(translation: drag?.translation ?? .zero)
        // Dragging ended or the long press cancelled.
        default:
            state = .inactive
        }
    }
    .onEnded { value in
        guard case .second(true, let drag?) = value else { return }
        self.viewState.width += drag.translation.width
        self.viewState.height += drag.translation.height
    }

return currentFloor
    .scaleEffect(self.scale)
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .offset(
                x: viewState.width + dragState.translation.width,
                y: viewState.height + dragState.translation.height
            )
            .animation(nil)
            .animation(.linear(duration: minimumLongPressDuration))
            .gesture(longPressDrag)
    }
}
}

struct SubmittedView : View {

    @Binding var currentRoom: String
    @Binding var destinationRoom: String
    
    @Binding var rooms: [String]
    
    @State private var CRHeight: CGFloat = 70
    @State private var DRHeight: CGFloat = 70
    
    @State private var CRResize: String = "Expand"
    @State private var DRResize: String = "Expand"
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme

    var body: some View {
        
        VStack {
            VStack {
                Text("Current Room")
                .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                    List {
                        HStack {
                            SearchBar(text: $currentRoom)
                            
                            Button(action: {

                                if self.CRHeight == 70 {
                                    self.CRResize = "Contract"
                                } else {
                                    self.CRResize = "Expand"
                                }
                                
                                withAnimation(.easeOut(duration: 0.15)) {
                                    if self.CRHeight == 70 {
                                        self.CRHeight = CGFloat.infinity
                                    } else {
                                        self.CRHeight = 70
                                    }
                                }
                                
                            }) {
                                ZStack {
                                    Text(CRResize)
                                        .foregroundColor(Color.blue)
                                        .zIndex(1)
                                    Rectangle()
                                    .fill(
                                        Color.clear
                                    )
                                }
                                }
                            .frame(width: 70)

                        }
                        .listRowBackground(colorScheme == .light ? Color.white : Color.black)

                        
                            ForEach(self.rooms.filter {
                                self.currentRoom.isEmpty ? true : $0.localizedStandardContains(self.currentRoom)
                            }, id: \.self) { room in
                                Button(action: {
                                    self.currentRoom = room
                                }) {
                                        Text(room)
                                    }
                            }
                        .listRowBackground(colorScheme == .light ? Color.white : Color.black)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: CRHeight)
                    .foregroundColor(.primary)
                .edgesIgnoringSafeArea(.all)
                
                
                Text("Destination Room")
                .font(.subheadline)
                    .fontWeight(.bold)
                    
                    List {
                        HStack {
                            SearchBar(text: $destinationRoom)
                            
                            Button(action: {
                                    
                                if self.DRHeight == 70 {
                                    self.DRResize = "Contract"
                                } else {
                                    self.DRResize = "Expand"
                                }
                                
                                withAnimation(.easeOut(duration: 0.15)) {
                                    if self.DRHeight == 70 {
                                        self.DRHeight = CGFloat.infinity
                                    } else {
                                        self.DRHeight = 70
                                    }
                                }
                                
                            }) {
                                ZStack {
                                    Text(DRResize)
                                        .foregroundColor(Color.blue)
                                    Rectangle()
                                    .fill(
                                        Color.clear
                                    )
                                }
                                }
                            .frame(width: 70)
                        }
                        .listRowBackground(colorScheme == .light ? Color.white : Color.black)
                
                        ForEach(self.rooms.filter {
                            self.destinationRoom.isEmpty ? true : $0.localizedStandardContains(self.destinationRoom)
                        }, id: \.self) { room in
                            Button(action: {
                                self.destinationRoom = room
                            }) {
                                    Text(room)
                                }
                        }
                        .listRowBackground(colorScheme == .light ? Color.white : Color.black)
                    }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: DRHeight)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
            
            }.background(colorScheme == .light ? Color.white : Color.black)
        .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SearchBar : UIViewRepresentable {
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    @Binding var text : String
    
    class Cordinator : NSObject, UISearchBarDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> SearchBar.Cordinator {
        return Cordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        
        uiView.backgroundColor = UIColor.black
        uiView.barTintColor = colorScheme == .light ? UIColor.white : UIColor.black
    }
}
