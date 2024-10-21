
import Foundation
import UIKit

class HighlightContainerCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var productData: [ProductData] = []

    var collectionView: UICollectionView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(HighlightCell.self, forCellWithReuseIdentifier: "highlightCell")

        contentView.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 380),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "highlightCell", for: indexPath) as! HighlightCell

        if productData.isEmpty {
            cell.imageView.image = UIImage(named: "placeHolder")

        } else {
            let product = productData[indexPath.item]
            cell.imageView.loadImage(from: product.imgUrl)
            cell.configure(labelTexts: [product.name, " \(String(format: "%.1f", product.ratingStar)) (\(product.ratingCount)) | 6K+ 已訂購"])

            if product.discount > 0.01 && product.discount <= 0.99 {
                cell.gradientView.isHidden = false
                cell.discountLabel.text = " \(String(format: "%.0f", product.discount * 100))% OFF"
            }

            cell.price.text = "\(product.currency) \(product.price)"

            if product.price != product.originPrice{
                cell.originPrice.textColor = .gray
                cell.originPrice.attributedText = NSAttributedString(
                    string: "\(product.currency) \(product.originPrice)",
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue
                    ]
                )
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productData[indexPath.item]
        open(urlString: "https://www.kkday.com/zh-tw/product/\(product.id)")
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.frame.size
    }

    // MARK: - Configure

    func configure(with detail: Detail){
        
        if let productDetails = detail.productDetails {
            productData = productDetails
        }
        
        collectionView.reloadData()
    }
}

