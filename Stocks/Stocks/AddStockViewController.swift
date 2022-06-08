
import UIKit
import AVFoundation
import CoreData

protocol addstockiewControllerDelegate: class {
    func addstockViewControllerDidCancel(
        _ controller: AddStockViewController)
    func addStockViewController(
        _ controller: AddStockViewController,
        didFinishAdding item: Stockitem)
}

class AddStockViewController: UITableViewController{
    
    var manageObjectContext: NSManagedObjectContext!
    
    var audioPlayer: AVAudioPlayer?
    weak var delegate: addstockiewControllerDelegate?
    var itemToView: Stockitem?
    
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var openlabel: UILabel!
    @IBOutlet var closelabel: UILabel!
    @IBOutlet var volumelabel: UILabel!
    @IBOutlet var highlabel: UILabel!
    @IBOutlet var lowlabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var AfterHours: UILabel!
    var searchresults = [SearchResult]()
    let item = Stockitem()
    
    func showNetworkerror() {
        let alert = UIAlertController(
        title: "We couldn't find what you're looking for",
        message: "There is a miscpelling error or an error with your internet connection. Please Try again",
        preferredStyle: .alert)
        let action = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
            
        }
        
    func performerSearch() {
        searchBar.resignFirstResponder()
        print(searchBar.text!)
        
        let url = stocksearch(searchText: searchBar.text!)
        if let data = performsearch(with: url){
            print("Received: \(data)")
            
            do{
            let decoder = JSONDecoder()
            let results = try decoder.decode(SearchResult.self, from: data)
            print ("Got results: \(results)")
                let openprice = String(results.open)
                let closeprice = String(results.close)
                let volume = String(results.volume)
                let highprice = String(results.high)
                let lowprice = String(results.low)
                let afterhours = String(results.afterHours)
                openlabel.text = openprice
                closelabel.text = closeprice
                volumelabel.text = volume
                highlabel.text = highprice
                lowlabel.text = lowprice
                AfterHours.text = afterhours
                
            }
            catch {
                print("JSON Error: \(error)")
            }
        
        
        
    }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        searchBar.searchTextField.clearButtonMode = .never

        
        if let item = itemToView {
            closelabel.text = item.close
            searchBar.text = item.symbol
            openlabel.text = item.open
            lowlabel.text = item.low
            highlabel.text = item.high
            volumelabel.text = item.volume
            AfterHours.text = item.afterHours
            doneBarButton.isEnabled = false
        }
        
    }
    @IBAction func cancel(){
        delegate?.addstockViewControllerDidCancel(self)
    }
    @IBAction func done(){
        print("searchbar text \(searchBar.text!)")
        let item = Stockitem()
        item.close = closelabel.text!
        item.symbol = searchBar.text!
        item.open = openlabel.text!
        item.afterHours = AfterHours.text!
        item.low = lowlabel.text!
        item.volume = volumelabel.text!
        item.high = highlabel.text!
        let pathToSound = Bundle.main.path(forResource: "clean-fast-swooshaiff-14784", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            audioPlayer?.play()
        }
        catch {
            print("COULDNT PLAY SOUND: \(error.localizedDescription)")
        }
        
        //MARK: Core Data
        let stock = StocksCoreData(context: manageObjectContext)
        stock.low = item.low
        stock.close = item.close
        stock.open = item.open
        stock.afterHours = item.afterHours
        stock.preMarket = item.preMarket
        stock.volume = item.volume
        stock.high = item.high
        stock.symbol = item.symbol
        stock.from = item.from
        stock.status = item.status
        do {
            try manageObjectContext.save()
        }
        catch{
            fatalError("Error: \(error)")
            
        }
        
        
        delegate?.addStockViewController(self, didFinishAdding: item)
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func stocksearch(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://api.polygon.io/v1/open-close/%@/2022-05-20?adjusted=true&apiKey=x3NDFp6TxTF9qNSbCXyZzeL4tWoFGUsH", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    func performsearch(with url: URL) -> Data?{
        do{
            doneBarButton.isEnabled = true
            return try Data(contentsOf: url)
        } catch {
            print("Downloaded error: \(error.localizedDescription)")
            let pathToSound = Bundle.main.path(forResource: "stop-13692", ofType: "mp3")!
            let url = URL(fileURLWithPath: pathToSound)
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                
                audioPlayer?.play()
            }
            catch {
                print("COULDNT PLAY SOUND: \(error.localizedDescription)")
            }
            showNetworkerror()
            doneBarButton.isEnabled = false
            return nil
        }
    }
    func parse(data: Data) ->[SearchResult]{
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Result.self, from: data)
            return result.results
        }
        catch{
            print("JSON ERROR: \(error)")
            //showNetworkerror()
            return []
        }
}
    
}
 extension AddStockViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("searchbar text \(searchBar.text!)")
        performerSearch()

        
        tableView.reloadData()
        
        
        
    }
     func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         let OldText = searchBar.text!
         let stringRange = Range(range, in: OldText)!
         let newText = OldText.replacingCharacters(in: stringRange, with: text)
         
         if newText != OldText{
             doneBarButton.isEnabled = false
         }
         
        else {
            doneBarButton.isEnabled = true
            }
         
             
        
         return true
     }
 }
