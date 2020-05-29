//
//  ClipsTableViewController.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class ClipsTableViewController: UITableViewController {

    // MARK: - Properites

    var clipController: ClipController?
    var clip: Clip? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Outlets

    // MARK: - Actions

    @IBAction func shareButton(_ sender: Any) {
        if let indexPath = tableView.indexPathForSelectedRow {
            outputEvents(row: indexPath.row)
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clipController?.clips.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClipCell", for: indexPath)

        if let clip = clipController?.clips[indexPath.row] {
            cell.textLabel?.text = clip.title
        }

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let clip = clipController?.clips[indexPath.row] {
                clipController?.delete(clip: clip)
            }

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private

    private func outputEvents(row index: Int) {
        if let clip = clipController?.clips[index] {
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short

            print("Report For: \(clip.title!)")
            print("Start Date: \(df.string(from: clip.startTimestamp!))")
            print("")

            if let events = clip.events?.allObjects as? [Event] {
                if !events.isEmpty {
                    for event in events {
                        print("\(event.name!) at \(df.string(from: event.timestamp!))")
                    }
                } else {
                    print("Empty. No events recorded for this clip")
                }
            } else {
                print("These are not the events records you are looking for")
            }
        }
    }
}
