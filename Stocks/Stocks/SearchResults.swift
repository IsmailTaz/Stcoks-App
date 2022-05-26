
import Foundation

class Result: Codable{
    let results = [SearchResult]()
}
struct SearchResult: Codable{
    var status: String = ""
    var from: String = ""
    var symbol: String = ""
    var open: Double = 0.0
    var high: Double = 0.0
    var low: Double = 0.0
    var close: Double = 0.0
    var volume: Int = 0
    var afterHours: Double = 0.0
    var preMarket: Double = 0.0
    
}
struct Root: Decodable{
    let searchresult: SearchResult
}
