import UIKit
import SafariServices

class SearchNewsViewController: UIViewController {
    var searchresults = [Article]()
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFond = "NothingFoundCell"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)

        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    }
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    func showNetworkerror() {
        let alert = UIAlertController(
        title: "We couldn't find what you're looking for",
        message: "There is a miscpelling error or an error with your internet connection. Please Try again",
        preferredStyle: .alert)
        let action = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
            
        }
    func stocksearch(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://newsapi.org/v2/everything?q=%@&apiKey=fd215a9ec5f341feb6673451a07e3877", encodedText)
        let url = URL(string: urlString)
    
        return url!
}

func parse(data: Data) ->[Article]{
    do{
        let decoder = JSONDecoder()
        let result = try decoder.decode(Newsresponse.self, from: data)
        
        return result.articles
    }
    catch{
        print("JSON ERROR: \(error)")
        showNetworkerror()
        return []
    }
}
    }
   
   


//MARK: searchbardelegates
extension SearchNewsViewController: UISearchBarDelegate{
    func position(for bar: UIBarPosition) -> UIBarPosition {
        return .topAttached
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performerSearch()
    }
    func performerSearch() {
        searchBar.resignFirstResponder()
        print(searchBar.text!)
        
        if !searchBar.text!.isEmpty {
            let url = stocksearch(searchText: searchBar.text!)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) {data, response, error in
                if let error = error {
                    print ("Failure: \(error.localizedDescription)")
                }
                else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchresults = self.parse(data: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                }
                else {
                    print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.showNetworkerror()
                }
            }
            dataTask.resume()
        }
        
    }
    
    
}
//MARK: tableview delegates
extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchresults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = TableView.CellIdentifiers.searchResultCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
        if searchresults.count == 0 {
            cell.titleLabel.text = "(NOThing found)"
            cell.subtitleLabel.text = ""
        }
        else {
        let searchResult = searchresults[indexPath.row]
        
            cell.configure(for: searchResult)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = searchresults[indexPath.row]
        
        guard let url = URL(string: article.url) else{
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}
