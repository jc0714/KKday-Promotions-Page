
import UIKit

class HighlightCell: UICollectionViewCell {

    let imageView = UIImageView()
    let heartButton = UIButton()

    let gradientLayer = CAGradientLayer()
    let gradientView = UIView()
    let discountLabel = UILabel()

    let starImage = UIImageView()
    let name = UILabel()
    let star = UILabel()
    let originPrice = UILabel()
    let price = UILabel()
    private var isHeartSelected: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        heartButton.setImage(UIImage(named: "ic-card-wish-normal"), for: .normal)
        heartButton.translatesAutoresizingMaskIntoConstraints = false

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 6
        gradientLayer.cornerRadius = 6
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        starImage.image = UIImage(named: "ratingStar")
        starImage.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        originPrice.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(gradientView)
        contentView.addSubview(discountLabel)
        contentView.addSubview(name)
        contentView.addSubview(starImage)
        contentView.addSubview(star)
        contentView.addSubview(originPrice)
        contentView.addSubview(price)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        name.textAlignment = .left
        star.textAlignment = .left
        originPrice.textAlignment = .left
        price.textAlignment = .left

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalToConstant: 190),

            heartButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            heartButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            heartButton.widthAnchor.constraint(equalToConstant: 30),
            heartButton.heightAnchor.constraint(equalToConstant: 30),

            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 79),
            gradientView.heightAnchor.constraint(equalToConstant: 20),

            discountLabel.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            discountLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            discountLabel.widthAnchor.constraint(equalTo: gradientView.widthAnchor),
            discountLabel.heightAnchor.constraint(equalTo: gradientView.heightAnchor),

            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            starImage.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            starImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            starImage.heightAnchor.constraint(equalToConstant: 18),
            starImage.widthAnchor.constraint(equalToConstant: 18),

            star.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            star.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            star.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            originPrice.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 8),
            originPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            originPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            price.topAnchor.constraint(equalTo: originPrice.bottomAnchor, constant: 8),
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            price.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.gradientLayer.frame = self.gradientView.bounds
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeHolder")
        imageView.layer.cornerRadius = 10
        price.text = nil
        originPrice.text = nil
        originPrice.attributedText = nil

        isHeartSelected = false
        updateHeartButtonImage()
    }

    func configure(labelTexts: [String]) {
        name.text = labelTexts[0]
        star.text = labelTexts[1]

        gradientView.isHidden = true
        updateHeartButtonImage()

        price.font = UIFont.boldSystemFont(ofSize: 16)
        name.font = UIFont(name: "HelveticaNeue", size: 16)
        name.numberOfLines = 0
        star.font = UIFont(name: "HelveticaNeue", size: 16)
        discountLabel.textColor = .white
        discountLabel.font = UIFont(name: "HelveticaNeue", size: 16)

        originPrice.textColor = .gray
        originPrice.font = UIFont(name: "HelveticaNeue", size: 16)
    }

    @objc private func heartButtonTapped() {
        isHeartSelected.toggle()
        updateHeartButtonImage()
    }

    private func updateHeartButtonImage() {
        let imageName = isHeartSelected ? "wishActive" : "wishNormal"
        heartButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
