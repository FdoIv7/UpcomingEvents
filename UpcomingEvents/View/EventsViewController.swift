//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 29/11/21.
//

import UIKit
import ChameleonFramework


class EventsViewController: UIViewController, EventPresenterDelegate {

    var events = [Event]()
    var sortedEvents = [Event]()
    var conflictingEvents = [Event]()
    
    let images = ImagesArray()
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
        
        
        let colors = [UIColor(hexString: "00c6ff"), UIColor(hexString: "0072ff")]
        self.view.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: self.view.frame, andColors: colors as [Any])
        
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
    
    @IBAction func warningButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Conflicting Event", message: "This event overlaps with other event in your schedule. Please check them out", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got It", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - TableView Methods

extension EventsViewController : UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let dateFormatter = DateFormatter()
        
        //Get event for indexPath.row
        let event = self.sortedEvents[indexPath.row]
        
        dateFormatter.dateFormat = "YYYY, MMM d, HH:mm"
        
        //cell.textLabel?.text = "\(sortedEvents[indexPath.row].title), \(dateFormatter.string(from: sortedEvents[indexPath.row].start))"
        
        cell.setupEventCell(withEvent: sortedEvents[indexPath.row], withImage: images.images[indexPath.row])
        
        cell.warningSignButton.isHidden = self.conflictingEvents.contains(event) ? false : true

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    
}

