

import UIKit


class PromoContainerCell: UITableViewCell {

    var collectionView: UICollectionView!
    
    private let leftGradientView = UIView()
    private let rightGradientView = UIView()
    
    var configDetail: Detail?
    
    var tabs: [String] = []
    
    var products: [ProductData] = []
    
    var selectedTabIndex = 0
    
    private var layout: PromoLayoutType = .grid
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        collectionView.register(PromoTabCell.self, forCellWithReuseIdentifier: "TabCell")
        collectionView.register(PromoProductCell.self, forCellWithReuseIdentifier: "ProductCell")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.layoutIfNeeded()
        let height = collectionView.contentSize.height
        return CGSize(width: targetSize.width, height: height)
    }
    
    func configure(with detail: Detail) {
        self.configDetail = detail
        
        let factory = CollectionViewFactory()
        guard let layoutType = configDetail?.layout else { return }
        
        switch layoutType {
        case "GRID":
            layout = .grid
        case "ROW":
            layout = .row
        case "TAB_GRID":
            layout = .tabGrid
        case "TAB_ROW":
            layout = .tabRow
        default:
            print("不支援的 layoutType")
            return
        }
        
        collectionView.collectionViewLayout = factory.createLayout(for: layout)
        
        if let configDetail = configDetail {
            if layout == .tabGrid || layout == .tabRow {
                
                self.tabs = []
                self.products = []
                
                self.tabs = configDetail.tabs!.map{ $0.name }
                
                guard let productDetails = configDetail.tabs?[selectedTabIndex].productDetails else { return }
                
                self.products = Array(productDetails.prefix(8))
                
                collectionView.reloadData()
                
                setupLeftGradientView()
                setupRightGradientView()
                
                factory.scrollCallback = { [weak self] visibleItems, point in
                    guard let self = self else { return }
                    
                    if point.x <= 0 {
                        self.leftGradientView.isHidden = true
                    } else {
                        self.leftGradientView.isHidden = false
                        self.rightGradientView.isHidden = false
                    }
                }
                
            } else {
                
                self.products = []
                
                guard let productDetails = configDetail.productDetails else { return }
                
                self.products = Array(productDetails.prefix(8))
                
                collectionView.reloadData()

            }
        } else {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PromoContainerCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if layout == .tabGrid || layout == .tabRow {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if layout == .tabGrid || layout == .tabRow {
            return section == 0 ? tabs.count : products.count
        } else {
            return min(products.count, 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if layout == .tabGrid || layout == .tabRow {
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! PromoTabCell
                
                cell.configure(with: tabs[indexPath.item], isSelected: indexPath.item == selectedTabIndex)
                
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! PromoProductCell
                
                if indexPath.item < products.count {
                    cell.configure(with: products[indexPath.item])
                }
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! PromoProductCell
            
            if indexPath.item < products.count {
                cell.configure(with: products[indexPath.item])
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PromoContainerCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if layout == .tabGrid || layout == .tabRow {
            if indexPath.section == 0 {
                selectedTabIndex = indexPath.item
                
                self.products = []
                
                guard let productDetails = configDetail?.tabs?[selectedTabIndex].productDetails else { return }
                
                self.products = Array(productDetails.prefix(8))
                
                collectionView.reloadData()
            
            } else {
                
                if let product = self.configDetail?.tabs?[selectedTabIndex].products[indexPath.item] {
                    
                    let productId = product.productUrlId
                    
                    let openUrl = "https://www.kkday.com/zh-tw/product/\(productId)"
                    open(urlString: openUrl)
                }
            }
            
        } else {
            if let product = self.configDetail?.products?[indexPath.item] {
                
                let productId = product.productUrlId
                
                let openUrl = "https://www.kkday.com/zh-tw/product/\(productId)"
                open(urlString: openUrl)
            }
        }
    }
}

extension PromoContainerCell {
    func setupLeftGradientView() {
        let layer0 = CAGradientLayer()
        
        layer0.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        layer0.locations = [0.35, 1.0]
        layer0.startPoint = CGPoint(x: 0, y: 0.5)
        layer0.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer0.frame = leftGradientView.bounds
        leftGradientView.layer.insertSublayer(layer0, at: 0)
        
        contentView.addSubview(leftGradientView)
        
        leftGradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftGradientView.widthAnchor.constraint(equalToConstant: 50),
            leftGradientView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        contentView.bringSubviewToFront(leftGradientView)
        leftGradientView.layoutIfNeeded()
        layer0.frame = leftGradientView.bounds
    }
    
    func setupRightGradientView() {
        let layer0 = CAGradientLayer()
          
        layer0.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        layer0.locations = [0.35, 1.0]
        layer0.startPoint = CGPoint(x: 1, y: 0.5)
        layer0.endPoint = CGPoint(x: 0, y: 0.5)
        
        layer0.frame = rightGradientView.bounds
        rightGradientView.layer.insertSublayer(layer0, at: 0)
        
        contentView.addSubview(rightGradientView)
        
        rightGradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightGradientView.widthAnchor.constraint(equalToConstant: 50),
            rightGradientView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        contentView.bringSubviewToFront(rightGradientView)
        rightGradientView.layoutIfNeeded()
        layer0.frame = rightGradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rightGradientView.removeFromSuperview()
        leftGradientView.removeFromSuperview()
    }
}
