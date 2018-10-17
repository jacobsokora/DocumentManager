//
//  EditViewController.swift
//  FileStorage
//
//  Created by Jacob Sokora on 10/7/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
	
	@IBOutlet weak var documentTypeSegmentedControl: UISegmentedControl!
	@IBOutlet weak var documentTitleTextField: UITextField!
	@IBOutlet weak var documentContentTextView: UITextView!
	
	var document: Document?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if let document = document {
			documentTitleTextField.text = document.title
			documentContentTextView.text = document.content
			title = "Edit File"
		} else {
			title = "New File"
		}
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		guard let title = documentTitleTextField.text, let content = documentContentTextView.text else {
			return
		}
		documentManagers[documentTypeSegmentedControl.selectedSegmentIndex].saveDocument(named: title, content: content)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
