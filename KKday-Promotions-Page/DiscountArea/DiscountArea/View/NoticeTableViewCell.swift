import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let bulletPointsLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        containerView.backgroundColor = UIColor(hex: "#F1F4F8")
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        bulletPointsLabel.numberOfLines = 0
        bulletPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bulletPointsLabel)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bulletPointsLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            bulletPointsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            bulletPointsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            bulletPointsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    func configure(with detail: Detail) {
        let attributedText = NSMutableAttributedString()
        
        if let contents = detail.contents {
            for content in contents {
                let bulletPoint = createBulletPoint()
                let bulletItemText = NSAttributedString(string: " \(content)\n", attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .light),
                    .paragraphStyle: createParagraphStyle()
                ])
                attributedText.append(bulletPoint)
                attributedText.append(bulletItemText)
            }
        }
        
        bulletPointsLabel.attributedText = attributedText
    }
    
    private func createBulletPoint() -> NSAttributedString {
        let bulletPointAttachment = NSTextAttachment()
        let bulletSize: CGFloat = 6
        
        bulletPointAttachment.bounds = CGRect(x: 0, y: (UIFont.systemFont(ofSize: 14).capHeight - bulletSize) / 2, width: bulletSize, height: bulletSize)
        bulletPointAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor(.black)
        
        return NSAttributedString(attachment: bulletPointAttachment)
    }

    private func createParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.headIndent = 12 + 8
        
        return paragraphStyle
    }
}
