

import UIKit

class MerchantCouponTableViewCell: UITableViewCell {
    
    lazy var merchantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Merchant Name"
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    lazy var merchantDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor(hex: "727272")
        label.numberOfLines = 2
        return label
    }()
    lazy var rightArrowImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        
        let verticalStackView = UIStackView(arrangedSubviews: [merchantNameLabel, merchantDescriptionLabel])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 0
        
        let horizontalStackView = UIStackView(arrangedSubviews: [merchantImageView, verticalStackView, rightArrowImageview])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 12
        
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            merchantImageView.widthAnchor.constraint(equalToConstant: 48),
            merchantImageView.heightAnchor.constraint(equalToConstant: 48),
            rightArrowImageview.widthAnchor.constraint(equalToConstant: 20),
            rightArrowImageview.heightAnchor.constraint(equalToConstant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func updateCell(from coupon: MerchantCoupon) {
        self.merchantNameLabel.text = coupon.title
        self.merchantDescriptionLabel.text = coupon.desc
        
        if let imageUrl = URL(string: coupon.logoImageUrl) {
            self.merchantImageView.loadImage(from: imageUrl)
        }
    }
    
}

class ShowMoreCell: UITableViewCell {
    
    private let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("展開更多", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(.black).cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(showMoreButton)
        
        NSLayoutConstraint.activate([

            showMoreButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            //showMoreButton.heightAnchor.constraint(equalToConstant: 48),
            showMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            showMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            showMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

        ])
    }
    
    func setButtonTarget(target: Any?, action: Selector) {
        showMoreButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func showButton(isExpanded: Bool) {
        showMoreButton.isHidden = isExpanded
    }
    
    func updateShowMoreButtonTitle(with itemCount: Int) {
        let title = String(format: "展開更多 (%d)", itemCount)
        showMoreButton.setTitle(title, for: .normal)
    }
}
