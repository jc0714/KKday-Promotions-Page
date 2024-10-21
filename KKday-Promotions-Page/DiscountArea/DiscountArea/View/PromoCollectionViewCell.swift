

import UIKit

// MARK: - Section 1 : TabCell
class PromoTabCell: UICollectionViewCell {
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        button.configuration = config
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.isUserInteractionEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        button.setTitle(title, for: .normal)
        
        if isSelected {
            button.setTitleColor(UIColor(hex: "#26BEC9"), for: .normal)
            button.layer.borderColor = UIColor(hex: "#26BEC9").cgColor
            button.backgroundColor = UIColor(hex: "#F0FAFB")
        } else {
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor(hex: "#D5D6DB").cgColor
            button.backgroundColor = .white
        }
    }
}

// MARK: - Section 2 : ProductCell

class PromoProductCell: UICollectionViewCell {

    // MARK: Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()

    let heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "wishNormal"), for: .normal)
        return button
    }()

    let discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()

    let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()

    let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "ratingStar")
        return iv
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#666666")
        return label
    }()

    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#9C9DA0")
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()

    private let gradientLayer = CAGradientLayer()

    var productId: String?
    private var isHeartSelected: Bool = false


    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.gradientLayer.frame = self.gradientView.bounds
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        discountLabel.text = nil
        nameLabel.text = nil
        ratingLabel.text = nil
        originalPriceLabel.text = nil
        priceLabel.text = nil
        isHeartSelected = false
        productId = nil
        updateHeartButtonImage()
    }

    // MARK: Setup
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(discountLabel)
        contentView.addSubview(heartButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingStackView)
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(priceLabel)

        [imageView, gradientView, discountLabel, heartButton, nameLabel, ratingStackView, originalPriceLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.55),

            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 79),
            gradientView.heightAnchor.constraint(equalToConstant: 20),

            discountLabel.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            discountLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            discountLabel.widthAnchor.constraint(equalTo: gradientView.widthAnchor),
            discountLabel.heightAnchor.constraint(equalTo: gradientView.heightAnchor),

            heartButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14),

            originalPriceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            originalPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            priceLabel.topAnchor.constraint(equalTo: originalPriceLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])

        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)

        setupGradientLayer()
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor(hex: "#FFAF1E").cgColor, UIColor(hex: "#FFD56E").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: Configuration
    func configure(with product: ProductData) {
        if let url = URL(string: product.imgUrl) {
            imageView.loadImage(from: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        discountLabel.text = "\(Int(product.discount * 100))% OFF"
        nameLabel.text = product.name
        ratingLabel.text = "\(String(format: "%.1f", product.ratingStar))(\(product.ratingCount))"
        originalPriceLabel.text = "TWD \(product.originPrice)"
        originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough()
        priceLabel.text = "TWD \(product.price) 起"

        self.productId = product.id
        updateWishlistStatus()

        originalPriceLabel.isHidden = product.originPrice == product.price
        gradientView.isHidden = product.discount <= 0.01 || product.discount >= 1
        discountLabel.isHidden = product.discount <= 0.01 || product.discount >= 1
    }

    // MARK: Wishlist Handling
    private func updateWishlistStatus() {
        guard let productId = productId else { return }
        isHeartSelected = WishStorageManager.shared.isProductInWishlist(productId: productId)
        updateHeartButtonImage()
    }

    private func updateHeartButtonImage() {
        let imageName = isHeartSelected ? "wishActive" : "wishNormal"
        heartButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func heartButtonTapped() {
        guard let productId = productId else { return }
        isHeartSelected.toggle()
        WishStorageManager.shared.toggleWishlistStatus(for: productId, isSelected: isHeartSelected)
        updateHeartButtonImage()
    }
}

