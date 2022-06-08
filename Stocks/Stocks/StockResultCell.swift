

import UIKit

class StockResultCell: UITableViewCell {
    
    @IBOutlet var symboLabel: UILabel!
    @IBOutlet var closeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
