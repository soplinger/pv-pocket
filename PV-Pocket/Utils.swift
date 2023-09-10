//
//  Utils.swift
//  PV-Pocket
//
//  Created by pad22 on 12/4/19.
//  Copyright © 2019 Todd Kocher. All rights reserved.
//
import Foundation
import SwiftyJSON
import Promises
import SystemConfiguration

//MARK: getResponse
func getResponse(_ url: String, _ post: Bool) -> Promise<JSON> {
    let response:Promise<JSON> = Promise<JSON>(on: .global()) {fulfill, reject in
        var request = URLRequest(url: URL(string: url)!);
        request.httpMethod = post ? "POST" : "GET";
        let session = URLSession.shared;
        session.dataTask(with: request){data, response, err in
            let jsonResponse: String = String(bytes: data!, encoding: .utf8)!
            
            if let dataFromString = jsonResponse.data(using: .utf8, allowLossyConversion: false) {
                let json = try! JSON(data: dataFromString)
                fulfill(json);
            }
            
        }.resume();
    }
    return response;
}

//MARK: Course
// Define a struct to comtain information about a course
public struct Course: Hashable {
    var name: String = ""
    var enrollmentCode: String = ""
    var url: String = ""
    var id: String = ""
    var room: String = ""
    var teacher: Person = Person()
    
    // Make this a Hashable type - will be used when comparing objects of this struct
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


//MARK: Assignment
// Define a struct to contain information about an assignment
public struct Assignment: Hashable {
    var title: String = ""
    var description: String = ""
    var points: Int = 0
    var url: String = ""
    var id: String = ""
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//MARK: Person
public struct Person: Hashable {
    var firstName: String = ""
    var lastName: String = ""
    var emailAddress: String = ""
    var id: String = ""
    var photoURL: String = ""
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//MARK: getClasses
func getClasses(_ accessToken: String, callback: @escaping ([Course: [Assignment]]) -> Void) {
   
    // Retrieve a list of the users classes
    getResponse("https://classroom.googleapis.com/v1/courses?access_token=\(accessToken)&studentId=me&courseStates=ACTIVE", false)
        .then { response in
            // Create an empty dictionary comprised of a Course and an array of Assignments
            var obj: [Course: [Assignment]] = [:];
            // Create an empty array to store the web requests needed
            var reqQueue: [Promise<JSON>] = [];
            // For each course the user has, add a web request to the above array to get the assignments in that course and the teacher of the course
            for i in 0..<response["courses"].count {
                reqQueue.append(getResponse("https://classroom.googleapis.com/v1/courses/\(response["courses"][i]["id"])/courseWork?access_token=\(accessToken)", false));
                reqQueue.append(getResponse("https://classroom.googleapis.com/v1/userProfiles/\(response["courses"][i]["ownerId"])?access_token=\(accessToken)", false))
                
            }
            
            // Initiate all webrequests at once
            all(reqQueue).then {reqResponses -> [Course: [Assignment]] in
                // For each response returned from the web requests
                // Count by 2 to compensate for one teacher for every course
                for i in stride(from: 0, to: reqResponses.count, by: 2) {
                    // Define a JSON object for the course
                    let curCourse: JSON = response["courses"][i / 2]
                    // Define a JSON object for the teacher
                    let curTeacher = reqResponses[i + 1]
                    // Define a Course object for the course
                    let curCourseObj: Course = Course(name: curCourse["name"].string!, enrollmentCode: curCourse["enrollmentCode"].string!, url: curCourse["alternateLink"].string!, id: curCourse["id"].string!, room: curCourse["room"] != JSON.null ? curCourse["room"].string! : "", teacher: Person(firstName: curTeacher["name"]["givenName"].string!, lastName: curTeacher["name"]["familyName"].string!, emailAddress: curTeacher["emailAddress"].string!, id: curTeacher["id"].string!, photoURL: curTeacher["photoUrl"].string!))
                    // Define a JSON object for the coursework in course 'i'
                    let curAssignments: JSON = reqResponses[i]["courseWork"]
                    // Iterate through every assignment in the course
                    for a in 0..<curAssignments.count {
                        let courseWork: JSON = curAssignments[a]
                        
                        // Parse due date
                        let dueDate: JSON = courseWork["dueDate"]
                        let dueYear: JSON = dueDate["year"]
                        let dueMonth: JSON = dueDate["month"]
                        let dueDay: JSON = dueDate["day"]
                        let dueTime: JSON = courseWork["dueTime"]
                        let dueHour: JSON = dueTime["hours"]
                        let dueMinute: JSON = dueTime["minutes"]
                        
                        // Ensure the due date exists before trying to compare it
                        if (dueYear != JSON.null && dueMonth != JSON.null && dueDay != JSON.null) {
                            var dueDateComponents = DateComponents()
                            dueDateComponents.year = dueYear.intValue
                            dueDateComponents.month = dueMonth.intValue
                            dueDateComponents.day = dueDay.intValue
                            dueDateComponents.hour = dueHour.intValue
                            dueDateComponents.minute = dueMinute.intValue
                            
                            let date = Date()
                            let calendar = Calendar.current

                            // Get the hour offset between Google's timezone and the users timezone
                            let timeZoneOffset = NSTimeZone.system.secondsFromGMT(for: date) / 3600
                            
                            // Add the offset to the current time and adjust the date accordingly
                            dueDateComponents.hour! += timeZoneOffset
                            if (dueDateComponents.hour! < 0) {
                                dueDateComponents.day! -= 1
                                dueDateComponents.hour! = 24 + dueDateComponents.hour!
                            }
                            
                            // Current date
                            let day = calendar.component(.day, from: date)
                            let month = calendar.component(.month, from: date)
                            let year = calendar.component(.year, from: date)
                            
                            // Due today
                            //if (year == dueDateComponents.year && month == dueDateComponents.month && day == dueDateComponents.day) {
                                
                            // Due tomorrow
                            //if (year == dueDateComponents.year && month == dueDateComponents.month && day + 1 == dueDateComponents.day) {
                            
                            // Due this week
                            //if (year == dueDateComponents.year && month == dueDateComponents.month && dueDateComponents.day! - day <= 7 && dueDateComponents.day! - day >= 0) {
                            
                            // Due this month
                            //if (year == dueDateComponents.year && month == dueDateComponents.month && day <= dueDateComponents.day!) {
                            
                            // Testing
                            if (true) {
                                
                                // Complete photo url
                                //print("https:" + curCourseObj.teacher.photoURL)
                                
                                // Define an Assignment object containing information about this assignment
                                let assignment: Assignment = Assignment(title: courseWork["title"].string!, description: courseWork["description"] != JSON.null ? courseWork["description"].string! : "", points: courseWork["maxPoints"] != JSON.null ? courseWork["maxPoints"].int! : 0, url: courseWork["alternateLink"].string!, id: courseWork["id"].string!)
                                
                                // Initiate an array for the course if it doesn't exist so we can add Assignments to it
                                if (obj[curCourseObj] == nil) {
                                    obj[curCourseObj] = []
                                }
                                // Append the Assignment to the Assignment array for this Course object
                                obj[curCourseObj]!.append(assignment)
                            }
                        }
                    }
                }
                return obj;
            }.then {classes in
                // Run callback and pass the data we organized
                callback(classes)
            }
    }
}

func getAnnouncements(callback: @escaping ([String: [String]]) -> Void) {
    //let TAGS = ["seniors","juniors","sophomores","freshman","sports","clubs"]
    let pref = ["SENIOR","SPORTS","CLUB", "SOPHOMORE"]
    print("you work")
    let promise = getResponse("https://appdesign.cloud.pvsd.org/get_data", false).then {json -> [String: [String]] in
        //object containing all the announcements sorted by tag
        var obj: [String: [String]] = [:]
        
        print("loading")
        //print(json)
        for i in 0...json["1"].count-1{
            // gets tags and announcements from json object
            var tags:[String] = []
            for j in 0...json["1"][i]["tags"].count-1{
                tags.append(json["1"][i]["tags"][j].stringValue)
            }
            let announcement = json["1"][i]["body"].stringValue
            
            let fTags = tags.map {$0.uppercased()}
            
            print(fTags)
            if tags.contains("ALL STUDENTS"){
                if (obj["ALL STUDENT"] == nil){
                    obj["ALL STUDENT"] = []
                }
                obj["ALL STUDENT"]?.append(announcement)
            }
            
            for temp in pref {
                if (fTags.contains(temp)){
                    print(temp)
                    if (obj[temp] == nil){
                        obj[temp] = []
                    }
                    obj[temp]?.append(announcement)
                }
            }
        }
        //returns announcement object to be called back to appdelegate
        return obj
    }.then { announcements in
        callback(announcements)
    }
}

//MARK: CheckConnection
func CheckConnection() -> Bool {
        
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
        
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
        
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
        
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
}
