//
//  DocumentManager.swift
//  FileStorage
//
//  Created by Jacob Sokora on 10/8/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import Foundation

let documentManagers: [DocumentManager] = [ICloudDocumentManager(), LocalDocumentManager()]

class ICloudDocumentManager: DocumentManager {
	
	var containerUrl: URL? {
		let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
		if let url = url, !FileManager.default.fileExists(atPath: url.path) {
			do {
				try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
			} catch {
				return nil
			}
		}
		return url
	}
	
	func loadDocuments() -> [Document] {
		var documents = [Document]()
		if let containerUrl = containerUrl, let files = try? FileManager.default.contentsOfDirectory(atPath: containerUrl.absoluteString) {
			for file in files {
				if let document = loadDocument(named: file) {
					documents.append(document)
				}
			}
		}
		return documents
	}
	
	func loadDocument(named fileName: String) -> Document? {
		guard let documentUrl = containerUrl?.appendingPathComponent(fileName),
				let body = try? String(contentsOf: documentUrl) else {
			return nil
		}
		return Document(title: fileName, content: body, documentManager: self)
	}
	
	func saveDocument(named fileName: String, content: String) -> Bool {
		guard let documentURl = containerUrl?.appendingPathComponent(fileName) else {
			return false
		}
		return FileManager.default.createFile(atPath: documentURl.absoluteString, contents: content.data(using: .utf8), attributes: nil)
	}
	
	func deleteDocument(named fileName: String) -> Bool {
		guard let documentUrl = containerUrl?.appendingPathComponent(fileName) else {
			return false
		}
		try? FileManager.default.removeItem(at: documentUrl)
		return true
	}

	func getName() -> String {
		return "iCloud"
	}
}

class LocalDocumentManager: DocumentManager {
	
	var filePath: String? {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
	}
	
	func loadDocuments() -> [Document] {
		var documents = [Document]()
		if let path = filePath, let files = try? FileManager.default.contentsOfDirectory(atPath: path) {
			for file in files {
				if let document = loadDocument(named: file) {
					documents.append(document)
				}
			}
		}
		return documents
	}
	
	func loadDocument(named fileName: String) -> Document? {
		guard let path = filePath, FileManager.default.changeCurrentDirectoryPath(path),
			let data = FileManager.default.contents(atPath: fileName), let body = String(data: data, encoding: .utf8) else {
			return nil
		}
		return Document(title: fileName, content: body, documentManager: self)
	}
	
	func saveDocument(named fileName: String, content: String) -> Bool {
		guard let path = filePath, FileManager.default.changeCurrentDirectoryPath(path) else {
			return false
		}
		return FileManager.default.createFile(atPath: fileName, contents: content.data(using: .utf8), attributes: nil)
	}
	
	func deleteDocument(named fileName: String) -> Bool{
		guard let path = filePath, FileManager.default.changeCurrentDirectoryPath(path) else {
			return false
		}
		try? FileManager.default.removeItem(atPath: fileName)
		return true
	}
	
	func getName() -> String {
		return "Local"
	}
}

protocol DocumentManager {
	
	func loadDocuments() -> [Document]
	
	func loadDocument(named fileName: String) -> Document?
	
	func saveDocument(named fileName: String, content: String) -> Bool
	
	func deleteDocument(named fileName: String) -> Bool
	
	func getName() -> String
}

struct Document {
	var title: String
	var content: String
	var size: Int {
		return content.utf8.count
	}
	var documentManager: DocumentManager
}
