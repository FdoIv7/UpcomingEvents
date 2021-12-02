//
//  Event.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 29/11/21.
//

import Foundation

struct Event: Decodable & Equatable {
    let title : String
    let start : Date
    let end : Date
    var interval : DateInterval {
        .init(start: start, end: end)
    }
    
    //Coding keys
    enum CodingKeys : String, CodingKey {
        case title, start, end
    }
    
    //Custom decoding init
    init(from decoder : Decoder) throws {
        
        //Create decoding container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //Set title from decoded string
        self.title = try container.decode(String.self, forKey: .title)
        
        //Decoded Data as Strings
        let startString = try container.decode(String.self, forKey: .start)
        let endString = try container.decode(String.self, forKey: .end)
        
        //Create Date Objects from decoded Strings
        self.start = DateFormatter.customDateFormatter.date(from: startString)!
        self.end = DateFormatter.customDateFormatter.date(from: endString)!
    
    }
    
    //Regular init for manually adding events
    init (title: String, start: Date, end: Date){
        self.title = title
        self.start = start
        self.end = end
    }
    
    //check if an event interval overlaps with another events interval
    func overlaps(with event: Event) -> Bool {
        //Using swifts built in intersects dateInterval func
        return interval.intersects(event.interval)
    }
}
