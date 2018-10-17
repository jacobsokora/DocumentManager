//
//  FilesViewController.swift
//  FileStorage
//
//  Created by Jacob Sokora on 10/7/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController {

	@IBOutlet weak var filesTableView: UITableView!
	@IBOutlet weak var documentTypeSegmentedControl: UISegmentedControl!
	
	var documents = [Document]()
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		filesTableView.dataSource = self
		documents = documentManagers[documentTypeSegmentedControl.selectedSegmentIndex].loadDocuments()
		filesTableView.reloadData()
    }
    
	@IBAction func documentTypeChanged(_ sender: Any) {
		documents = documentManagers[documentTypeSegmentedControl.selectedSegmentIndex].loadDocuments()
		filesTableView.reloadData()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if let destination = segue.destination as? EditViewController, let selected = documents[filesTableView.indexPathForSelectedRow.row] {
			destination.document = selected
		}
	}

}

extension FilesViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return documents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
		cell.textLabel?.text = documents[indexPath.row].title
		cell.detailTextLabel?.text = "\(documents[indexPath.row].size) bytes"
		return cell
	}
}
