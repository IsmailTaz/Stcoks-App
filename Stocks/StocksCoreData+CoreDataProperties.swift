
import Foundation
import CoreData


extension StocksCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StocksCoreData> {
        return NSFetchRequest<StocksCoreData>(entityName: "StocksCoreData")
    }

    @NSManaged public var status: String
    @NSManaged public var open: String
    @NSManaged public var high: String
    @NSManaged public var low: String
    @NSManaged public var close: String
    @NSManaged public var preMarket: String
    @NSManaged public var afterHours: String
    @NSManaged public var from: String
    @NSManaged public var symbol: String
    @NSManaged public var volume: String

}

extension StocksCoreData : Identifiable {

}
