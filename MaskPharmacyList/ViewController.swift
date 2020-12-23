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
    var pharmacyDatas : [PharmacyData] = []
    var pharmacyDictionary : [String : [PharmacyData]] = [:]
    var quote = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let pharmacyDatas = UserDefaults.standard.object(forKey: "pharmacyData") as! [PharmacyData]
        //        print("pharmacyDatas \(pharmacyDatas)")
        
        navigationItem.rightBarButtonItem = editButtonItem
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing)) // create a bat button
        navigationItem.rightBarButtonItem = editButton // assign button
        quote = networkController.fetchDailyQuote()
        networkController.fetchPharmacyData{ result in
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let pharmacyData):
                self.pharmacyDatas = pharmacyData
                DispatchQueue.main.async {
                    
                    // core data
                    //As we know that container is set up in the AppDelegates so we need to refer that container.
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    
                    //We need to create a context from this container
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    //Now let’s create an entity and new user records.
                    let userEntity = NSEntityDescription.entity(forEntityName: "PharmacyEntity", in: managedContext)!
                    let cmsg = NSManagedObject(entity: userEntity, insertInto: managedContext)
                    
                    let datas = Data(features: pharmacyData)
                    cmsg.setValue(datas, forKeyPath: "pharmacyData")
                    
                    do {
                        try managedContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        print(quote)
    }
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
}

// TableView Delegate Methods

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharmacyDatas.count
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
            pharmacyDatas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
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
