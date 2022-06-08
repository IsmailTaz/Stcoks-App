import UIKit
import CoreData

class ThirdSearchTableViewController: UITableViewController, addstockiewControllerDelegate, UINavigationControllerDelegate {
    
    func addstockViewControllerDidCancel(_ controller: AddStockViewController) {
        navigationController?.popViewController(animated: true)
    }
    var controller : StockResultCell = StockResultCell()
    var manageObjectContext: NSManagedObjectContext!
    
    func addStockViewController(_ controller: AddStockViewController, didFinishAdding item: Stockitem) {
        let newRowIndex = Stocksitem.count
        Stocksitem.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveStocksItems()
        
        //UserDefaults.setValue(item.close, forKey: "StocksIndex")
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "StocksIndex")
        }
    }
    
    var Stocksitem = [Stockitem]()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "AddStock"{
            
            let controller = segue.destination as! AddStockViewController
            controller.delegate = self
            controller.manageObjectContext = manageObjectContext
            
        }
        else if segue.identifier == "Viewquote" {
            let controller = segue.destination as! AddStockViewController
            controller.delegate = self
            let indexPath = sender as! IndexPath
            controller.itemToView = Stocksitem[indexPath.row]
            controller.manageObjectContext = manageObjectContext
            }
        }
    //MARK: Crashes the app
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = UserDefaults.standard.integer(forKey: "StocksIndex")
        if index != -1 {
            let quote = Stocksitem[index]
            performSegue(withIdentifier: "Viewquote", sender: quote)
        }
    }
     */
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "StockResultCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "StockResultCell")
        title = "Stocks"
        loadStocksItems()

       print("Document for Folde is \(documentsDirectory())")
    print("DATA file path is \(dataFilePath())")
        // snavigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Stocksitem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StockResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StockResultCell
        let item = Stocksitem[indexPath.row]
        cell.symboLabel.text = item.symbol
        cell.closeLabel.text = item.close
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Stocksitem.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveStocksItems()
       // UserDefaults.setValue(indexPath.row, forKey: "Stock")
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "StocksIndex")
        
       
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "Viewquote", sender: indexPath)
        
    }
    
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath()-> URL {
        return documentsDirectory().appendingPathComponent("Stocks.plist")
    }
    func saveStocksItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(Stocksitem)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding Stocksitem array : \(error.localizedDescription)")
        }
    }
    
    func loadStocksItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do {
                Stocksitem = try decoder.decode([Stockitem].self, from: data)
            }
            catch {
                print("Error deecoding Stocksitem array : \(error.localizedDescription)")
            }
        }
    }
     

    

}
