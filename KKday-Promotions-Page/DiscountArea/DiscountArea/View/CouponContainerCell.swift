

import UIKit

protocol CouponContainerCellDelegate: AnyObject {
    func didSelectCoupon()
}

class CouponContainerCell: UITableViewCell {
    
    var couponTableView = UITableView()
    weak var delegate: CouponContainerCellDelegate?
    var couponList: [Coupon] = [] {
        didSet {
            couponTableView.reloadData()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        couponTableView.dataSource = self
        couponTableView.delegate = self
        couponTableView.isScrollEnabled = false
        couponTableView.register(CouponTableViewCell.self, forCellReuseIdentifier: "CouponTableViewCell")
        
        contentView.addSubview(couponTableView)
        couponTableView.separatorStyle = .none
        
        couponTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            couponTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            couponTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24 ),
            couponTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            couponTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        couponTableView.layoutIfNeeded()
        let tableViewHeight = couponTableView.contentSize.height
        return CGSize(width: targetSize.width, height: tableViewHeight)
    }
    
    func configure(with coupons: [Coupon]) {
        self.couponList = coupons
    }
}

//MARK: - Merchant Coupon TableView DataSource
extension CouponContainerCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
        let coupon = couponList[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.redeemAction = { [weak self] in
            self?.delegate?.didSelectCoupon()
        }
        
        cell.configure(with: coupon)
        return cell
    }
}
