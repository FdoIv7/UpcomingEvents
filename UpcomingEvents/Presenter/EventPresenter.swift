//
//  EventPresenter.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 01/12/21.
//

import Foundation
import UIKit

protocol EventPresenterDelegate: AnyObject {
    //Any of the functions that the controller is going to conform to and implement
    //Any "present" stuff
    func presentEvents(events: [Event])
    func presentSortedEvents(eventsToSort: [Event])
}

class EventPresenter {
    
    //Not storing a strong reference
    weak var delegate : (EventPresenterDelegate  & UIViewController)?
        
    public func setViewDelegate(delegate: EventPresenterDelegate & UIViewController){
        //Set our delegate with delegate from parameter
        self.delegate = delegate
    }
    
    //Logic for reading our local JSON File fileName as argument
    private func readJSONFile(file fileName: String) -> Data?{
        //Catch any potential errors
        do {
            //Safely get our bundlePath and safely try to get Data from our bundlePath
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),  let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                //We got some JSON Data back
                return jsonData
            }
        } catch {
            print("error getting JSON Data \(error)")
        }
        //No JSON Data Back
        return nil
    }
    
    //Method for parsing JSONData
    private func parseData(jsonData : Data){
        //Create our decoder
        let decoder = JSONDecoder()
        
        do {
            //Decode our JSONData and get an Event Array
            let decodedEvents = try decoder.decode([Event].self, from: jsonData)
            
            //We can safely tell our presenter to present Events
            delegate?.presentEvents(events: decodedEvents)
            
            /*
            ------- Printing to visualize for testing -------
             
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY, MMM d, HH:mm:ss"
             
            var i = 0
            while i < decodedData.count{
                print("Event title: \(decodedData[i].title)")
                print("Start Date: \(dateFormatter.string(from: decodedData[i].start))")
                print("End Date: \(dateFormatter.string(from: decodedData[i].end))")
                print("Interval : \(decodedData[i].interval)")
                print("--------")
                
                i += 1
            }
            ------- Printing to visualize for testing -------
            */
            
        } catch {
            print("error parsing jsonData \(error)")
        }
    }
    
    //Read and parse our JSONFile to get Events
    public func getEvents(){
        if let localData = self.readJSONFile(file: "mock") {
            parseData(jsonData: localData)
        }
    }
    
    public func checkForOverlap(with eventArray: [Event]) -> [Event]{
    
        //create an array to store our conflicting events
        var conflictingEvents = [Event]()
        
        if eventArray.count < 2 {
            //There's just one event, return array with our only element - just to not get an empty array
            conflictingEvents.append(eventArray[0])
            return conflictingEvents
        }
        
        //This could easily be replaced by var a = 0 but going like this to understand it's the indexOf - (.indexOf()) is deprecated
        var currentEvent = eventArray.firstIndex(of: eventArray[0])! as Int
        //This could easily be replaced by var b = 1 but going like this to understand it's the indexOf - (.indexOf()) is deprecated
        var nextEvent = eventArray.firstIndex(of: eventArray[1])! as Int
        
        //Iterate through our events
        while (nextEvent < eventArray.count) {

            //Check if events overlap
            if eventArray[currentEvent].overlaps(with: eventArray[nextEvent]){
                
                //If they overlap add check for any duplicates in conflictingEvents array
                //If currentEvent doesn't exist, append it to conflictingEvents
                
                if !conflictingEvents.contains(eventArray[currentEvent]) {
                    conflictingEvents.append(eventArray[currentEvent])
                }
                
                //We can safely append nextEvent, even if when currentEvent gets set as nextEvent we are previously checking for duplicates
                conflictingEvents.append(eventArray[nextEvent])
                print("\(eventArray[currentEvent].title) overlaps with \(eventArray[nextEvent].title)")
            } else {
                //No overlap between events, make currentEvent the next clear event as everything before is conflicting
                currentEvent = nextEvent
            }
            //Add 1 to nextEvent for loop purposes and to make sure to check all elements
            nextEvent += 1
        }
        for n in 0...conflictingEvents.count - 1 {
            print("conflicting event #\(n): \(conflictingEvents[n].title)")
        }
        return conflictingEvents
    }
}
