//
//  ViewController.swift
//  MaskMap
//
//  Created by CharlesLin on 2020/12/23.
//

import UIKit
import Kanna
import CoreData

class ViewController: UITableViewController {
    var networkController = NetworkController() // can call it manager or helper if you prefer; DI to later on VCs
    var pharmacyDatas : [Pharmacy] = []
    var quote = ""
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // MARK: - NSFetchedResultsController

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Pharmacy> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Pharmacy> = Pharmacy.fetchRequest()
        let predicate = NSPredicate(format: "properties_.county_ == %@", "臺中市")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "properties_.town_", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    func updateView() {
        if let pharmacies = fetchedResultsController.fetchedObjects , pharmacies.count > 0 {
            self.pharmacyDatas = pharmacies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupView() {
        navigationItem.rightBarButtonItem = editButtonItem
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetch()
    }
    
    
    func fetch() {
        quote = networkController.fetchDailyQuote()
        networkController.fetchPharmacyData{ result in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let pharmacyData):
                    self.saveContext(incomingData: pharmacyData)
                    self.fetchContext()

            }
        }
    }

    // MARK: - Core Data Fetching

    func fetchContext() {
//        let predicate = NSPredicate(format: "properties_.county_ == %@", "臺中市")
//        let pharmacies = try? managedContext.fetch(Pharmacy.fetchRequest(predicate))
//        self.pharmacyDatas = pharmacies ?? []
//        updateView()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

        self.updateView()
        
    }

    // MARK: - Core Data Saving

    func saveContext (incomingData: [PharmacyInfo]) {
        let json = JsonData(context: managedContext)
        if UserDefaultsSingleton.firstWriteJson {
            return
        } else {
            UserDefaultsSingleton.firstWriteJson = true
        }

        var pharmacyList : [Pharmacy] = []
        print("incomingData.count \(incomingData.count)")
        for pharmacy in incomingData {
            let properties = Properties(context: managedContext)
            properties.name = pharmacy.properties.name
            properties.county = pharmacy.properties.county
            properties.town = pharmacy.properties.town
            let pharmacy_ = Pharmacy(context: managedContext)
            pharmacy_.properties = properties
            pharmacyList.append(pharmacy_)
        }

        json.pharmacies_ = NSSet.init(array: pharmacyList)

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
}

// MARK: - TableView Delegate Methods

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pharmacies = fetchedResultsController.fetchedObjects else { return 0 }
        print("pharmacies.count \(pharmacies.count)")
        return pharmacies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath) as! PharmacyCell
        cell.name.text = pharmacyDatas[indexPath.row].properties.name
        cell.town.text = pharmacyDatas[indexPath.row].properties.town
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Fetch pharmacy
            let pharmacy = fetchedResultsController.object(at: indexPath)

            // Delete Pharmacy
            pharmacy.managedObjectContext?.delete(pharmacy)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x:12,y: 0 ,width:UIScreen.main.bounds.width,height:100))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        titleLabel.text  = quote
        vw.addSubview(titleLabel)
        vw.backgroundColor = .cyan
        return vw
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
}


extension ViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

}
