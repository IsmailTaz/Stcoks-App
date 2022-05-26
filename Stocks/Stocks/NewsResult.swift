

import Foundation

struct Newsresponse: Codable{
    let articles : [Article]
}
struct Article: Codable{
    var source: Source
    var title: String = ""
    var description: String = ""
    var url: String = ""
    var urlToImage: String = ""
    var publishedAt: String = ""
    /*
    var titles: String {
        return "\n result for title: "
    }
    */
}
struct Source: Codable {
    let name: String
}
