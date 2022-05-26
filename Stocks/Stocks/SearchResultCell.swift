import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: Helper Methods
    func configure(for result: Article){
        titleLabel.text = result.title
        subtitleLabel.text = result.description
        articleImageView.image = UIImage (systemName: "square")
        if let urltoImage = URL(string: result.urlToImage){
            downloadTask = articleImageView.loadImage(url: urltoImage)
        }
    }

}
