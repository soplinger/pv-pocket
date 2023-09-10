//
//  CardView.swift
//  PV-Pocket
//
//  Created by Sean Oplinger on 11/25/19.
//  Copyright © 2019 Sean Oplinger. All rights reserved.
//

import SwiftUI

// MARK: CardView
struct CardView : View {
    
    var backOfCard: String
    
    var body: some View {
        return VStack {
            Text(backOfCard)
            }
        .frame(width: 340, height: 220.0)
        .foregroundColor(Color(.systemBackground))
        
    }
}

// MARK: WelcomeCard
//Creates Card in welcome view housing the ID
struct WelcomeCard : View {
    
    var cardTitle: String
    var cardLetterDay: String
    var schedule: String
    
    var body: some View {
        return VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(cardTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                    Text(cardLetterDay)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 5)
                    Text(schedule)
                        .font(Font.system(size: 14))
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()
            }
        .frame(width: UIScreen.main.bounds.width / 1.25, height: UIScreen.main.bounds.height / 4)
            .background(Color("icons"))
            .cornerRadius(10)
            .shadow(radius: 20)
    }
}

// MARK: TitleView
//UI Display element used at the top of all 4 tabs
//Sets the title for each tab view
struct TitleView : View {
    
    var viewTitle: String
    
    var body: some View {
        return VStack {
            HStack {
                Text(viewTitle)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    Spacer()
                }
                Spacer()
            }
            .padding()
    }
}

// MARK: BottomViewPull
//UI Display element used in the Settings and Profile views
//Bottom bar on Welcome screen
struct BottomViewPull : View {
    
    var bottomText: String
    
    var body: some View {
        return VStack(spacing: 20.0) {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
            Text(bottomText)
                .lineLimit(10)
            Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .padding(.horizontal)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(30)
            .shadow(radius: 20)
            .offset(y: 600)
        }
    }

// MARK: BottomView
//Same as BottomView but without the pull down tab
//Bottom bar on Welcome screen
struct BottomView : View {
    
    var bottomText: String
    
    var body: some View {
        return VStack(spacing: 20.0) {

            Text(bottomText)
                .lineLimit(10)
                .padding(.bottom, 6)
            Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .padding(.horizontal)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(30)
            .shadow(radius: 20)
            .offset(y: 600)
        }
    }


// MARK: VSmallCardView
//Create a verticle card for displaying information
//Not currently used
struct VSmallCardView: View {
    
    var image: String
    var category: String
    var title: String
    var author: String
    
    var body: some View {
        
        VStack {
            HStack {
            Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)

        VStack(alignment: .leading) {
            Text(category)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(title)
                .font(.system(size: 22))
                .fontWeight(.black)
                .foregroundColor(.primary)
                .lineLimit(3)
            Text(author.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                }
               
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

// MARK: VLargeCardView
//UI Display element used in the ClassroomView class to display users classes
//Creates a larger card to display information
struct VLargeCardView: View {
    
    var image: String
    var category: String
    var heading: String
    var author: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
 
            HStack {
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(heading)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    Text(author.uppercased())
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
    }
}
