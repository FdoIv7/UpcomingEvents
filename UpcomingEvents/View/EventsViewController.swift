//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 29/11/21.
//

import UIKit

class EventsViewController: UIViewController, EventPresenterDelegate {
    
    var events = [Event]()
    var sortedEvents = [Event]()
    var conflictingEvents = [Event]()
    
    private let eventPresenter = EventPresenter()
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        title = "Upcoming Events"

        //Set Presenter
        eventPresenter.setViewDelegate(delegate: self)
        eventPresenter.getEvents()
    }
    
    //If our presenter tells us that we can present our events
    func presentEvents(events: [Event]) {
        self.events = events
        presentSortedEvents(eventsToSort: events)
        self.conflictingEvents = eventPresenter.checkForOverlap(with: sortedEvents)
        
        DispatchQueue.main.async {
            self.eventsTableView.reloadData()
        }
    }
    
    func presentSortedEvents(eventsToSort: [Event]){
        sortedEvents = eventsToSort.sorted(by: { $0.start < $1.start})
    }
    
}

extension EventsViewController : UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let dateFormatter = DateFormatter()
        
        //Get event for indexPath.row
        let event = self.sortedEvents[indexPath.row]
        
        dateFormatter.dateFormat = "YYYY, MMM d, HH:mm"
        
        cell.textLabel?.text = "\(sortedEvents[indexPath.row].title), \(dateFormatter.string(from: sortedEvents[indexPath.row].start))"
        cell.backgroundColor = self.conflictingEvents.contains(event) ? .systemOrange : .clear

        return cell
    }
}

