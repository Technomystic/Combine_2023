//
//  ExampleOneViewController.swift
//  Combine_Day7
//
//  Created by Niraj on 08/01/2023.
//

import Combine
import UIKit

extension Notification.Name {
    static let newBlogPost = Notification.Name("newPost")
}

struct BlodPost {
    let title: String
}


class ExampleOneViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var publishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        publishButton.addTarget(self, action: #selector(publishButtonAction), for: .primaryActionTriggered)

        // Publisher
        let publisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
            .map { (notification) -> String? in
                return (notification.object as? BlodPost)?.title ?? ""
            }

        // Subscriber
        let subscriber = Subscribers.Assign(object: textLabel, keyPath: \.text)
        publisher.subscribe(subscriber)
        
    }

    @objc func publishButtonAction(_ sender: UIButton) {
        let blog = BlodPost(title: textField.text ?? "Coming Soon")
        NotificationCenter.default.post(name: .newBlogPost, object: blog)
    }

}
