
import Foundation
import UIKit


class TitleCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var subtitleLabel: UILabel? = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = UIColor(hex: "727272")
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        
        if let subtitleLabel = subtitleLabel {
            contentView.addSubview(subtitleLabel)
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
        
        if let subtitleLabel = subtitleLabel {
            NSLayoutConstraint.activate([
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
            ])
        } else {
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        }
    }
    
    func configure(with detail: Detail) {
        titleLabel.text = detail.title
        subtitleLabel?.text = detail.subtitle
        
        if subtitleLabel == nil {
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
        }
    }
}
