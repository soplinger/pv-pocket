//
//  LunchView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 11/23/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LunchView()
    }
}

struct LunchView : View {
    
    @State var showOrder = false
    @State var showMenu = false
    @EnvironmentObject var finalItem: DeliOrder

    
    var body: some View {
       ZStack {
            BlurView(style: .systemMaterial)
                TitleView(viewTitle: "PV Deli")
                
                ScrollView (showsIndicators: false) {
                    Button(action: {self.showMenu.toggle() }) {
                    VLargeCardView(image: "deliimage", category: "PV Deli", heading: "Welcome to the PV Deli!", author:"PAD22")
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: self.$showMenu)
                    {
                        LunchMenu()
                        .edgesIgnoringSafeArea(.all)
                    }
                    Button(action: { self.showOrder.toggle() }) {
                    VLargeCardView(image: "actualhoagie", category: "PV Deli", heading: "Click Here to Make Your Order!", author:"PAD22")
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: self.$showOrder)
                    {
                        LunchOrder()
                        .environmentObject(self.finalItem)
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            .offset(y: 60)

            }
            .navigationBarHidden(true) . navigationBarTitle("")
        }
    }

struct LunchMenu: View {
    
    var body: some View {
        ZStack {
            BlurView(style: .systemMaterial)
            TitleView(viewTitle: "PV Lunch Menu")
            
            ScrollView(showsIndicators: false) {
                    LunchMenuCard(cardTitle: "Your Way Deli", cardDesc: "Hoagies, Wraps, Sandwiches and Salads made your way! With a large variety of cheeses, chicken and meats")
                    LunchMenuCard(cardTitle: "Chicken Bar", cardDesc: "Chicken Patties, Spicy Chicken Patties, Baked Chicken Patties, Chicken Nuggets, Chicken Fingers and Premium Chicken Breasts")
                    LunchMenuCard(cardTitle: "Burger Bar", cardDesc: "Hamburgers, Cheeseburgers and Premium Bacon Cheeseburgers")
                    LunchMenuCard(cardTitle: "Greenhouse", cardDesc: "Grab and Go Fresh Salads")
                    LunchMenuCard(cardTitle: "Produce Stand", cardDesc: "Visit the Produce Stand daily for a selection of Fresh Fruits, Vegetables and Side Salads to compliment any meal")
                    LunchMenuCard(cardTitle: "Express Lane", cardDesc: "Grab & Go Sandwiches, Wraps & Meals")
                    LunchMenuCard(cardTitle: "Pizza Shoppe", cardDesc: "Cheese, Pepperoni and Other types of Pizza")
                }
                .padding(.top, 75)
                .padding(.trailing, 50)
            }
        }
    }


struct LunchMenuCard: View {
    
    var cardTitle: String
    var cardDesc: String

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .center) {
                    Text(cardTitle)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .padding(.bottom, 5)
                    Text(cardDesc)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
        .padding([.top, .horizontal])
    }
}








//MARK: Lunch Order
struct LunchOrder: View {
    
    var body: some View {
        ZStack
            {
                BlurView(style: .systemMaterial)
                TitleView(viewTitle: "PV Deli Order")
                    
                VStack{
                    ScrollView (showsIndicators: false) {
                        VStack {
                            BreadView()
                                .padding(.all, 15)
                        }
                        VStack {
                            MeatView()
                                .padding(.all, 15)
                        }
                        VStack {
                            CheeseView()
                                .padding(.all, 15)
                        }
                            SauceView()
                                .padding(.all, 15)
                        VStack {
                            VeggieView()
                                .padding(.all, 15)
                        }
                        VStack {
                            Text("Your Order Is")
                                .font(.largeTitle)
                            PictureView()
                        }
                        .padding(.all, 15)
                        .background(Color("background12"))
                        .cornerRadius(15)
                    }
                }
            .padding(.top, 75)
            Spacer()
        }
    }
}



//MARK: Bread
struct BreadView : View {
    
    @EnvironmentObject var numOfItems: DeliOrder
    @State var i = 0
    
    var body : some View {
        VStack{
            Text("Choose Your Bread")
                .font(Font.system(size: 30))
                .padding(.top, 2)
            
            ForEach((0...(numOfItems.breadArray.count - 1)), id: \.self) {
                efficientBreadView(item: $0)
            }
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
    }
}

//MARK: Bread Subviews
struct efficientBreadView : View {
    
    @EnvironmentObject var finalItem: DeliOrder
    var item : Int
    
    var body : some View {
        
        HStack {
            Text(finalItem.breadArray[item])
            Spacer()
            Button(action: {self.toggleItem(chosenItem: self.item)}) {
                if (finalItem.TFbreadArray[item]) {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    func toggleItem (chosenItem: Int) -> Void {
        
        var i = 0
        
        while (i < finalItem.breadArray.count) {
            if (i != chosenItem) {
                finalItem.TFbreadArray[i] = false
                if(finalItem.chosenItems.contains(finalItem.breadArray[i])){
                    finalItem.chosenItems.remove(at: finalItem.chosenItems.firstIndex(of: finalItem.breadArray[i])!)
                }
            } else {
                if (finalItem.TFbreadArray[chosenItem] == false) {
                    finalItem.chosenItems.append(finalItem.breadArray[chosenItem])
                }
            }
            i += 1
        }
        finalItem.TFbreadArray[chosenItem] = true

        print(finalItem.chosenItems)
    }
}


//MARK: Meat
struct MeatView : View {
    
    @EnvironmentObject var numOfItems: DeliOrder
    @State var i = 0
    
    var body : some View {
        VStack{
            Text("Choose Your Meats")
                .font(Font.system(size: 30))
                .padding(.top, 2)
            
            ForEach((0...(numOfItems.meatArray.count - 1)), id: \.self) {
                efficientMeatView(item: $0)
            }
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
    }
}

//MARK: Meat Subviews
struct efficientMeatView : View {
    
    @EnvironmentObject var finalItem: DeliOrder
    var item : Int
    
    var body : some View {
        
        HStack {
            Text(finalItem.meatArray[item])
            Spacer()
            Button(action: {self.toggleItem(chosenItem: self.item)}) {
                if (finalItem.TFmeatArray[item]) {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    func toggleItem (chosenItem: Int) -> Void {
        finalItem.TFmeatArray[chosenItem].toggle()
        
        if (finalItem.TFmeatArray[chosenItem]) {
            finalItem.chosenItems.append(finalItem.meatArray[chosenItem])
        } else {
            if(finalItem.chosenItems.contains(finalItem.meatArray[chosenItem])){
                finalItem.chosenItems.remove(at: finalItem.chosenItems.firstIndex(of: finalItem.meatArray[chosenItem])!)
            }
        }

        print(finalItem.chosenItems)
    }
}


//MARK: Cheese
struct CheeseView : View {
    
    @EnvironmentObject var numOfItems: DeliOrder
    @State var i = 0
    
    var body : some View {
        VStack{
            Text("Choose Your Cheeses")
            .font(Font.system(size: 30))
            .padding(.top, 2)
            
            ForEach((0...(numOfItems.cheeseArray.count - 1)), id: \.self) {
                efficientCheeseView(item: $0)
            }
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
    }
}

//MARK: Cheese Subviews
struct efficientCheeseView : View {
    
    @EnvironmentObject var finalItem: DeliOrder
    var item : Int
    
    var body : some View {
        
        HStack {
            Text(finalItem.cheeseArray[item])
            Spacer()
            Button(action: {self.toggleItem(chosenItem: self.item)}) {
                if (finalItem.TFcheeseArray[item]) {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    func toggleItem (chosenItem: Int) -> Void {
        finalItem.TFcheeseArray[chosenItem].toggle()
        
        if (finalItem.TFcheeseArray[chosenItem]) {
            finalItem.chosenItems.append(finalItem.cheeseArray[chosenItem])
        } else {
            if(finalItem.chosenItems.contains(finalItem.cheeseArray[chosenItem])){
                finalItem.chosenItems.remove(at: finalItem.chosenItems.firstIndex(of: finalItem.cheeseArray[chosenItem])!)
            }
        }

        print(finalItem.chosenItems)
    }
}



//MARK: Sauce
struct SauceView : View {
    
    @EnvironmentObject var numOfItems: DeliOrder
    @State var i = 0
    
    var body : some View {
        VStack{
            Text("Choose Your Sauces")
                .font(Font.system(size: 30))
                .padding(.top, 2)
            
            ForEach((0...(numOfItems.sauceArray.count - 1)), id: \.self) {
                efficientSauceView(item: $0)
            }
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
    }
}

//MARK: Sauce Subviews
struct efficientSauceView : View {
    
    @EnvironmentObject var finalItem: DeliOrder
    var item : Int
    
    var body : some View {
        
        HStack {
            Text(finalItem.sauceArray[item])
            Spacer()
            Button(action: {self.toggleItem(chosenItem: self.item)}) {
                if (finalItem.TFsauceArray[item]) {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    func toggleItem (chosenItem: Int) -> Void {
        finalItem.TFsauceArray[chosenItem].toggle()
        
        if (finalItem.TFsauceArray[chosenItem]) {
            finalItem.chosenItems.append(finalItem.sauceArray[chosenItem])
        } else {
            if(finalItem.chosenItems.contains(finalItem.sauceArray[chosenItem])){
                finalItem.chosenItems.remove(at: finalItem.chosenItems.firstIndex(of: finalItem.sauceArray[chosenItem])!)
            }
        }

        print(finalItem.chosenItems)
    }
}



//MARK: Veggie
struct VeggieView : View {
    
    @EnvironmentObject var numOfItems: DeliOrder
    @State var i = 0
    
    var body : some View {
        VStack{
            Text("Choose Your Veggies")
                .font(Font.system(size: 30))
                .padding(.top, 2)
            
            ForEach((0...(numOfItems.veggieArray.count - 1)), id: \.self) {
                efficientVeggieView(item: $0)
            }
        }
        .padding(.bottom, 5)
        .padding(.top, 5)
        .background(Color("background12"))
        .cornerRadius(15)
    }
}

//MARK: Veggie Subviews
struct efficientVeggieView : View {
    
    @EnvironmentObject var finalItem: DeliOrder
    var item : Int
    
    var body : some View {
        
        HStack {
            Text(finalItem.veggieArray[item])
            Spacer()
            Button(action: {self.toggleItem(chosenItem: self.item)}) {
                if (finalItem.TFveggieArray[item]) {
                    Image(systemName: "checkmark.square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    func toggleItem (chosenItem: Int) -> Void {
        finalItem.TFveggieArray[chosenItem].toggle()
        
        if (finalItem.TFveggieArray[chosenItem]) {
            finalItem.chosenItems.append(finalItem.veggieArray[chosenItem])
        } else {
            if(finalItem.chosenItems.contains(finalItem.veggieArray[chosenItem])){
                finalItem.chosenItems.remove(at: finalItem.chosenItems.firstIndex(of: finalItem.veggieArray[chosenItem])!)
            }
        }

        print(finalItem.chosenItems)
    }
}


//MARK: Pictures
struct PictureView : View {
    
    @EnvironmentObject var finalOrder: DeliOrder
    var imageTest = "Pad22DeliAmericanCheese"
    
    var body : some View {
        VStack{
            if (finalOrder.chosenItems.isEmpty) {
                Text("No Items Selected")
            } else {
                ZStack{
                    //top bread
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        TopBreadPictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .zIndex(50)
                    .offset(y: -60)
                    //sauces
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        SaucePictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .offset(y: -30)
                    .zIndex(40.0)
                    //veggies
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        VeggiePictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .offset(y: -25)
                    .zIndex(30.0)
                    //cheese
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        CheesePictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .offset(y: 0)
                    .zIndex(20.0)
                    //meat
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        MeatPictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .offset(y: 40)
                    .zIndex(10.0)
                    //bottom bread
                    ForEach((0...(finalOrder.chosenItems.count - 1)), id: \.self) {
                        BottomBreadPictures(item: self.finalOrder.chosenItems[$0])
                    }
                    .offset(y: 55)
                    .zIndex(0.0)
                }
            }
        }
        .frame(height: 200)
    }
}

struct TopBreadPictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.breadArray.contains(item)) {
                if (item == "WheatBread") {
                    Image("TopWheatBun")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                } else if (item == "RyeBread") {
                    Image("TopRyeBun")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                } else if (item == "Roll") {
                    Image("Roll")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                }
            }
        }
    }
}
struct BottomBreadPictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.breadArray.contains(item)) {
                if (item == "WheatBread") {
                    Image("BottomWheatBun")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                } else if (item == "RyeBread") {
                    Image("BottomRyeBun")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                } else if (item == "Roll") {
                    Image("BottomWheatBun")
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                } else {
                    Image(item)
                        .padding(.bottom, -15)
                        .padding(.top, -15)
                }
            }
        }
    }
}
struct MeatPictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.meatArray.contains(item)) {
                Image(item)
                    .padding(.bottom, -15)
                    .padding(.top, -15)
            }
        }
    }
}
struct CheesePictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.cheeseArray.contains(item)) {
                Image(item)
                    .padding(.bottom, -15)
                    .padding(.top, -15)
            }
        }
    }
}
struct VeggiePictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.veggieArray.contains(item)) {
                Image(item)
                    .padding(.bottom, -15)
                    .padding(.top, -15)
            }
        }
    }
}
struct SaucePictures : View {

    @EnvironmentObject var DeliPicArray: DeliOrder
    var item : String
    
    var body : some View {
        VStack{
            if (DeliPicArray.sauceArray.contains(item)) {
                Image(item)
                    .padding(.bottom, -15)
                    .padding(.top, -15)
            }
        }
    }
}

