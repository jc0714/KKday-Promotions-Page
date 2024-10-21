

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    let backgroundImageView = UIImageView()
    let discountTitleLabel = UILabel()
    let discountCodeLabel = UILabel()
    let countdownLabel = UILabel()
    let redeemButton = UIButton(type: .system)
    var redeemAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none

        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.image = UIImage(named: "event_coupon_bg")
        contentView.addSubview(backgroundImageView)

        discountTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        discountTitleLabel.textColor = UIColor.systemTeal
        contentView.addSubview(discountTitleLabel)

        discountCodeLabel.font = UIFont.systemFont(ofSize: 14)
        discountCodeLabel.textColor = UIColor.gray
        contentView.addSubview(discountCodeLabel)
        
        countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        countdownLabel.textColor = UIColor.black
        countdownLabel.numberOfLines = 0
        contentView.addSubview(countdownLabel)

        let lineImageView = UIImageView(image: UIImage(named: "event_coupon_line"))
        lineImageView.contentMode = .scaleAspectFit
        contentView.addSubview(lineImageView)

        let decorImageView = UIImageView(image: UIImage(named: "coupon_bg_gray"))
        decorImageView.contentMode = .scaleAspectFill
        contentView.addSubview(decorImageView)
       
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: boldFont,
            .foregroundColor: UIColor.white
        ]
        
        let attributedTitle = NSAttributedString(string: "立即領取", attributes: titleAttributes)
        redeemButton.setAttributedTitle(attributedTitle, for: .normal)
        redeemButton.addTarget(self, action: #selector(redeemButtonTapped), for: .touchUpInside)
        redeemButton.backgroundColor = UIColor.systemTeal
        redeemButton.setTitleColor(.white, for: .normal)
        redeemButton.layer.cornerRadius = 4
        contentView.addSubview(redeemButton)
        
        let padding: CGFloat = 16
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        discountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        discountCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        lineImageView.translatesAutoresizingMaskIntoConstraints = false
        decorImageView.translatesAutoresizingMaskIntoConstraints = false
        redeemButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -6),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            discountTitleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: padding),
            discountTitleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: padding),
            discountTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundImageView.trailingAnchor, constant: -padding),

            discountCodeLabel.topAnchor.constraint(equalTo: discountTitleLabel.bottomAnchor, constant: 8),
            discountCodeLabel.leadingAnchor.constraint(equalTo: discountTitleLabel.leadingAnchor),
            discountCodeLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundImageView.trailingAnchor, constant: -padding),

            countdownLabel.topAnchor.constraint(equalTo: discountCodeLabel.bottomAnchor, constant: 8),
            countdownLabel.leadingAnchor.constraint(equalTo: discountCodeLabel.leadingAnchor),
            countdownLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundImageView.trailingAnchor, constant: -padding),
            countdownLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -8),

            lineImageView.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 16),
            lineImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: padding),
            lineImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -padding),
            lineImageView.heightAnchor.constraint(equalToConstant: 1),

            decorImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -padding),
            decorImageView.topAnchor.constraint(equalTo: discountTitleLabel.topAnchor),
            decorImageView.widthAnchor.constraint(equalToConstant: 400),
            decorImageView.heightAnchor.constraint(equalToConstant: 120),

            redeemButton.topAnchor.constraint(equalTo: lineImageView.bottomAnchor, constant: 16),
            redeemButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 130),
            redeemButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -130),
            redeemButton.heightAnchor.constraint(equalToConstant: 40),
            redeemButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -padding)
        ])
    }

    @objc private func redeemButtonTapped() {
        redeemAction?()
    }

    func configure(with coupon: Coupon) {
        discountTitleLabel.text = coupon.title
        discountCodeLabel.text = "折扣券：\(coupon.couponCode)"
        
        if coupon.isExpired {
            if let endDate = coupon.parseDate(from: coupon.endTime) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedEndDate = dateFormatter.string(from: endDate)
                countdownLabel.text = "優惠券已於 \(formattedEndDate) 過期"
            } else {
                countdownLabel.text = "優惠券已過期"
            }
        } else {
            let countdownText = """
            下殺優惠倒數\n\(coupon.daysRemaining) 日 \(coupon.hoursRemaining) : \(coupon.minutesRemaining) : \(coupon.secondsRemaining)
            """
            
            let attributedText = NSMutableAttributedString(string: countdownText)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: countdownText.count))
            
            let backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            let regex = try! NSRegularExpression(pattern: "\\d+")
            let matches = regex.matches(in: countdownText, range: NSRange(location: 0, length: countdownText.count))
            
            for match in matches {
                attributedText.addAttribute(.backgroundColor, value: backgroundColor, range: match.range)
            }
            
            countdownLabel.attributedText = attributedText
        }
    }
}

