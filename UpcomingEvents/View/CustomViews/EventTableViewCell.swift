//
//  EventTableViewCell.swift
//  UpcomingEvents
//
//  Created by Fernando Pérez Ruiz on 02/12/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventContainerView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventStartLabel: UILabel!
    @IBOutlet weak var eventEndLabel: UILabel!
    @IBOutlet weak var warningSignButton: UIButton!
    
    let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //Setting image for cell with imageString (There are better more efficient ways to implement this, but as it is just eye candy, we're going this way)
    func setupEventCell(withEvent event: Event, withImage imageString: String){
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        eventImageView.image = UIImage(named: imageString)
        eventTitleLabel.text = event.title
        eventStartLabel.text = "Starts: \(formatter.string(from: event.start))"
        eventEndLabel.text  = "Ends: \(formatter.string(from: event.end))"
        warningSignButton.isHidden = true
        
        eventImageView.layer.cornerRadius = 15.0
        eventImageView.layer.masksToBounds = true

        eventContainerView.layer.shadowOffset = .zero
        eventContainerView.layer.shadowRadius = 3
        eventContainerView.layer.shadowColor = UIColor.white.cgColor
        eventContainerView.layer.shadowOpacity = 0.5
        eventContainerView.layer.masksToBounds = false
        eventContainerView.layer.cornerRadius = 15.0

    }
}
