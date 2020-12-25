//
//  NetworkController.swift
//  MaskMap
//
//  Created by CharlesLin on 2020/12/23.
//

import Foundation
import Kanna
import CoreData

class NetworkController: NSObject {
    let queue = OperationQueue()
    let urlStr = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - NSFetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController<Pharmacy> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Pharmacy> = Pharmacy.fetchRequest()
        let predicate = NSPredicate(format: "properties_.county_ == %@", "臺中市")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "properties_.town_", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    override init() {}
    
    func fetchDailyQuote() -> String {
        var quote = ""
        let appledailyURL = URL(string: "https://tw.feature.appledaily.com/collection/dailyquote/20201223")!
        let html = try! String(contentsOf: appledailyURL, encoding: .utf8)
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            let text = doc.xpath("/html/body[@class='dailyquote']/div[@class='wrapper']/article/div[@class='book']/div[@class='textbox']/div[@class='rwdfix']/p[2]").first!
            quote = text.text ?? ""
        } catch {
            print("fetchDailyQuote failed.")
        }
        return quote
    }
    
    func fetchPharmacyData(completionHandler: @escaping (Result<[PharmacyInfo], Error>) -> Void) {
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    completionHandler(.failure(error!))
                    return
                }
                if let unfilteredData = try? JSONDecoder().decode(JsonInfo.self, from: data) {
//                    var processedPharmacyDatas = unfilteredData.features.filter { $0.properties.county == "臺中市" }
//                    processedPharmacyDatas = processedPharmacyDatas.sorted { $0.properties.town < $1.properties.town }
                    
                    completionHandler(.success(unfilteredData.features))
                }
            }.resume()
        } else {
            print("no url")
        }
    }
}
