//
//  DateFormatter+Extension.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 30/11/21.
//

import Foundation

extension DateFormatter {
    
    //Create our custom Dateformatter
    static let customDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        //Set our calendar with iso8601 standard
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM d, yyyy h:mm a"
        return formatter
        
    }()
    
}

