//
//  DataService.swift
//  AthenaHealth
//
//  Created by Saurav Satpathy on 13/12/19.
//  Copyright © 2019 Saurav Satpathy. All rights reserved.
//

import Foundation
import ZIPFoundation
import Alamofire
class DataService {
    enum File: String {
        case category = "CategoryList.json"
        case topics = "TopicsList.json"
        case topicsSubKey = "TopicsSubKey.json"
    }
    let dataUrl = "https://cdn.dev.epocrates.com/formulary/config/assignment.zip"
    func getData(completion: @escaping ((Categories, Topics, TopicSubKeys)->Void)) {
        let destination = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(dataUrl, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .userInitiated)) { (progress) in } .validate().responseData { ( response ) in
            print(response.destinationURL!.lastPathComponent)
            self.unzipFile(url: response.destinationURL!)
            let result = self.readDiseases(url: self.unzipPath!.appendingPathComponent("assignment/disease/list/"))
            completion(result.0, result.1, result.2)
        }
    }
    func unzipFile(url: URL) {
        let fileManager = FileManager()
        do {
            try? FileManager.default.removeItem(atPath: unzipPath!.path)
            try fileManager.createDirectory(at: unzipPath!, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: url, to: unzipPath!)
        } catch {
            print("Extraction of ZIP archive failed with error:\(error)")
        }
    }
    var unzipPath: URL? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/assignments"
        let url = URL(fileURLWithPath: path)
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return .none
        }
        return url
    }
    func readDiseases(url: URL) -> (Categories, Topics, TopicSubKeys) {
        var filePaths:[URL]?
        do {
            filePaths = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {}
        var categories: Categories?
        var topics: Topics?
        var topicSubKeys: TopicSubKeys?
        filePaths?.forEach { path in
            let file = File.init(rawValue: path.lastPathComponent)!
            let filePath = URL(fileURLWithPath: url.path).appendingPathComponent(file.rawValue)
            let jsonData = readJsonData(path: filePath)
            guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData!) as? [String:AnyObject] else {return}
            switch file {
            case .category:
                categories = Categories(uri: jsonDict!["uri"] as! String, content: jsonDict!["content"] as! [[Any]])
                break
            case .topics:
                topics = Topics(uri: jsonDict!["uri"] as! String, content: jsonDict!["content"] as! [[Any]])
                break
            case .topicsSubKey:
                topicSubKeys = TopicSubKeys(uri: jsonDict!["uri"] as! String, content: jsonDict!["content"] as! [[[Int]]])
                break
            }
        }
        return (categories!, topics!, topicSubKeys!)
    }
    
    func readJsonData(path: URL) -> Data? {
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path.path), options: .mappedIfSafe)
        } catch {
            
        }
        return .none
    }
    func readDisease(for key: String) -> String? {
        var filePaths:[URL]?
        let fileName = key+".json"
        let url = unzipPath?.appendingPathComponent("assignment/disease/monograph/\(fileName)")
        let jsonData = readJsonData(path: url!)
        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData!) as? [String:AnyObject] else {return .none}
            let title = jsonDict!["title"]
        return title as? String
    }
}
