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

//MARK:- MainMapView
struct MapView: View {
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    //@State var rect = CGRect()
    
    @State var currentRoom: String = ""
    @State var destinationRoom: String = ""
    
    //Arrays to save all existing rooms and what floor they're on
    @State var rooms: [String] = ["006","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","143","144","145","146","147","148","149","150","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","255","256","257","258","259","260","261","262","301","302","303","304","305","306","307","308","309","310","700","701","702","703","710","730","750","800","900","Auditorium","Cafeteria","CC","Conference","Counselor","Fitness Center","Old Gymnasium","New Gymnasium","IPC","ISS","Laboratory","Library","MO","Perkiomen_Valley_Virtual","TechL","UC"]
    @State var floors: [String] = ["N/A", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "2", "3", "3", "3", "3", "3", "3", "3", "3", "3", "3", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A"]
    
    //Image being displayed by the Secondary Map View Struct
    @State var currentFloor: Image = Image("NewMap_Floor1")
    
    //Sets overlay opacity when button is pressed
    @State var F1Active = true
    @State var F2Active = false
    @State var F3Active = false
    
    @State var roomAlert = false
    
    //Binds to MapView and Sends button
    @State var scale: CGFloat = (UIScreen.main.bounds.width / UIScreen.main.bounds.height) * 0.3
    
    @State var lockMap = false
    
    @State var viewState: CGSize = CGSize(width: CGSize.zero.width, height: CGSize.zero.height + (UIScreen.main.bounds.height * 0.45))
    
    private var buttonWidth = UIScreen.main.bounds.width / 3.5
    
    @State private var buttonColor: Color = .primary
    
    //function resets the scale according to the floor
    private func resetScaleAndCenter(floor: Int) {
        if (floor == 1) {
            self.scale = (UIScreen.main.bounds.width / UIScreen.main.bounds.height) * 0.3
            self.viewState = CGSize(width: CGSize.zero.width, height: CGSize.zero.height + (UIScreen.main.bounds.height * 0.45))
        } else if (floor == 2) {
            self.scale = (UIScreen.main.bounds.width / UIScreen.main.bounds.height) * 0.35
            self.viewState = CGSize(width: CGSize.zero.width, height: CGSize.zero.height + (UIScreen.main.bounds.height * 0.35))
        } else {
            self.scale = (UIScreen.main.bounds.width / UIScreen.main.bounds.height) * 0.5
            self.viewState = CGSize(width: CGSize.zero.width, height: CGSize.zero.height + (UIScreen.main.bounds.height * 0.45))
        }
    }
    
    var body: some View {
        
        ZStack {
            
            VStack {
                //Text("some text").background(GeometryGetter(rect: self.$rect))
                // You can then use rect in other places of your view:
                //Rectangle().frame(width: 100, height: rect.height)
                 BlurView(style: .systemMaterial)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                 .overlay(
                        MapView(viewState: self.$viewState, scale: self.$scale, currentFloor: self.$currentFloor, lockedView: self.$lockMap)
                ).background(BlurView(style: .systemMaterial))
                
                SlideOverCard(currentRoom: $currentRoom, destinationRoom: $destinationRoom, rooms: $rooms, floors: $floors, currentFloor: $currentFloor, roomAlert: $roomAlert, scale: $scale, lockMap: $lockMap, viewState: $viewState) {
                    //var buttonWidth = UIScreen.main.bounds.width / 3
                    VStack {
                        //Handle()
                        HStack {
                            Button(action: {
                                print(self.scale)
                                if self.lockMap {
                                    self.currentFloor = Image("NewMap_Floor1_White")
                                } else {
                                    self.currentFloor = Image("NewMap_Floor1")
                                }
                                
                                self.resetScaleAndCenter(floor: 1)
                                
                                self.F1Active = true
                                self.F2Active = false
                                self.F3Active = false
                                
                            }) {
                                HStack {
                                    Image(systemName: self.F1Active ? "map.fill" : "map")
                                        .foregroundColor(.blue)
                                    Text("1")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Rectangle()
                                    .fill (
                                        self.buttonColor
                                    )
                                    .frame(width: self.buttonWidth)
                                    .cornerRadius(20)
                                    )
                                }
                            Spacer()
                                .frame(width: self.buttonWidth / 2)
                        
                        Button(action: {
                            if self.lockMap {
                                self.currentFloor = Image("NewMap_Floor2_White")
                            } else {
                                self.currentFloor = Image("NewMap_Floor2")
                            }
                            
                            self.resetScaleAndCenter(floor: 2)
                            
                            self.F1Active = false
                            self.F2Active = true
                            self.F3Active = false

                        }) {
                            HStack {
                                Image(systemName: self.F2Active ? "map.fill" : "map")
                                    .foregroundColor(.blue)
                                Text("2")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Rectangle()
                            .fill (
                                self.buttonColor
                            )
                                .frame(width: self.buttonWidth)
                                .cornerRadius(20)
                                )
                            }
                            Spacer()
                                .frame(width: self.buttonWidth / 2)
                            
                            Button(action: {
                                if self.lockMap {
                                        self.currentFloor = Image("NewMap_Floor3_White")
                                    } else {
                                        self.currentFloor = Image("NewMap_Floor3")
                                    }
                                
                                self.resetScaleAndCenter(floor: 3)
                                
                                self.F1Active = false
                                self.F2Active = false
                                self.F3Active = true
                                
                            }) {
                                HStack {
                                    Image(systemName: self.F3Active ? "map.fill" : "map")
                                        .foregroundColor(.blue)
                                    Text("3")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                                .background(Rectangle()
                                .fill (
                                    self.buttonColor
                                )
                                .frame(width: self.buttonWidth)
                                .cornerRadius(20)
                                )
                                }
                        }
                        
                        HStack {
                            ZStack {
                                Text("^ Swipe up to find rooms ^")
                                .foregroundColor(Color.secondary.opacity(0.5))
                                Text("^ Swipe up to find rooms ^")
                                .foregroundColor(Color.secondary.opacity(0.1))
                                    .offset(x: 6)
                                Text("^ Swipe up to find rooms ^")
                                .foregroundColor(Color.secondary.opacity(0.1))
                                    .offset(x: -6)
                            }
                                
                        .alert(isPresented: self.$roomAlert) {
                                Alert(title: Text("Error:"), message: Text("please enter a valid current room"), dismissButton: .default(Text("Ok")))
                            }
                            
                            Text("\(self.currentRoom)")
                            
                            Text("\(self.destinationRoom)")
                            
                            
                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0, alignment: .center)
                            .padding(.all, 15)
                        
                        SubmittedView(currentRoom: self.$currentRoom, destinationRoom: self.$destinationRoom, rooms: self.$rooms)

                    }
                }
                
                Divider()
                    
            }.background(BlurView(style: .systemMaterial))
    }
        .navigationBarHidden(true) . navigationBarTitle("")
}


//MARK:- MapView struct
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
    
    @Binding var viewState: CGSize
    
    @Binding var scale: CGFloat
    @State var lastScaleValue: CGFloat = 1.0
    
    @Binding var currentFloor: Image
    
    @Binding var lockedView: Bool

var body: some View {
let minimumLongPressDuration = lockedView ? 1000.0 : 0.0
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
            .gesture(MagnificationGesture().onChanged { val in
                        let delta = val / self.lastScaleValue
                        self.lastScaleValue = val
                        self.scale = self.scale * delta
            //... anything else e.g. clamping the newScale
            }.onEnded { val in
              // without this the next gesture will be broken
              self.lastScaleValue = 1.0
            })
    }
}
}

struct SubmittedView : View {

    @Binding var currentRoom: String
    @Binding var destinationRoom: String
    
    @Binding var rooms: [String]
    
    @State private var CRLActive = false
    @State private var DRLActive = false
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme

    var body: some View {
        
        VStack {
            VStack {
                Text("Current Room")
                .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                
                    SearchBar(text: $currentRoom)
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(stiffness: 2, damping: 10)) {
                                self.CRLActive.toggle()
                                if self.DRLActive {
                                    self.DRLActive.toggle()
                                }
                            }
                        }
                    List {
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
                    .frame(height: CRLActive ? UIScreen.main.bounds.height / 2 : 0)
                    .foregroundColor(.primary)
                .edgesIgnoringSafeArea(.all)
                
                
                Text("Destination Room")
                .font(.subheadline)
                    .fontWeight(.bold)
                    
                        SearchBar(text: $destinationRoom)
                            .onTapGesture {
                                withAnimation(.interpolatingSpring(stiffness: 2, damping: 10)) {
                                    self.DRLActive.toggle()
                                    if self.CRLActive {
                                        self.CRLActive.toggle()
                                    }
                                }
                            }
                    List {
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
                    .frame(height: DRLActive ? UIScreen.main.bounds.height / 2 : 0)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
            
            }.background(colorScheme == .light ? Color.white : Color.black)
        .edgesIgnoringSafeArea(.all)
        }
    }
}


//MARK:- Search Bar View
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
    }
}

//MARK:-- Handle View
struct Handle : View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 40, height: 5)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

//MARK:-- SlideOverCard View
struct SlideOverCard<Content: View> : View {
    
    let keyWindow = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first
    
    @State var high = UIScreen.main.bounds.height * 0.1
    @State var low = UIScreen.main.bounds.height * 0.76
    
    @Binding var currentRoom: String
    @Binding var destinationRoom: String
    
    //Arrays to save all existing rooms and what floor they're on
    @Binding var rooms: [String]
    @Binding var floors: [String]
    
    //Image being displayed by the Secondary Map View Struct
    @Binding var currentFloor: Image
    
    @Binding var roomAlert: Bool
    
    //Binds to MapView and Sends button
    @Binding var scale: CGFloat
    
    @Binding var lockMap: Bool
    
    @Binding var viewState: CGSize
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    @GestureState private var dragState = DragState.inactive
    @State var position = UIScreen.main.bounds.height * 0.76
    
    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return Group {
            VStack {
                Handle()
                self.content()
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //Handle()
        }
        .frame(height: UIScreen.main.bounds.height, alignment: .top)
        .background(
            Rectangle()
                .fill(colorScheme == .light ? Color.white : Color.black)
        )
        .cornerRadius(20.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    //MARK:- validateRooms func
    private func validateRooms(roomP: String, rooms: [String]) -> Bool {
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
    
    private func onDragEnded(drag: DragGesture.Value) {
        //let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        //let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
        //let closestPosition: CardPosition
        
        if self.position == low {
            self.position = high
        } else {
            self.position = low
            keyWindow?.endEditing(true)
            
            /*
                @Binding var currentRoom: String
                @Binding var destinationRoom: String
                
                //Arrays to save all existing rooms and what floor they're on
                @Binding var rooms: [String]
                @Binding var floors: [String]
                
                //Image being displayed by the Secondary Map View Struct
                @Binding var currentFloor: Image
                
                @Binding var roomAlert: Bool
                
                //Binds to MapView and Sends button
                @Binding var scale: CGFloat
                
                @Binding var lockMap: Bool
                
                @Binding var viewState: CGSize
             */
            
            if validateRooms(roomP: currentRoom, rooms: rooms) && validateRooms(roomP: destinationRoom, rooms: rooms){
                // Both rooms are valid and exist
                lockMap = true
                
                switch (Int(currentRoom.prefix(1))) {
                case 1:
                    currentFloor = Image("NewMap_Floor1_White")
                case 2:
                    currentFloor = Image("NewMap_Floor2_White")
                case 3:
                    currentFloor = Image("NewMap_Floor3_White")
                default:
                    currentFloor = Image("NewMap_Floor1_White")
                }
            } else if (currentRoom.isEmpty || destinationRoom.isEmpty) {
                // Atleast one room text field is empty
                // Either the currentRoom or destinationRoom parameter are not valid or do not exist
                currentRoom = ""
                destinationRoom = ""
            } else {
                // Either the currentRoom or destinationRoom parameter are not valid or do not exist
                currentRoom = ""
                destinationRoom = ""
                roomAlert = true
            }
            
        }
        
    }
    
    
}

enum CardPosition: CGFloat {
    case high = 10
    case low = 500
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
