

import UIKit

class GuideCell: UICollectionViewCell {

    let imageView = UIImageView()
    let videoPlayIcon = UIButton()

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
        
        videoPlayIcon.setImage(UIImage(named: "Group_1"), for: .normal)
        videoPlayIcon.translatesAutoresizingMaskIntoConstraints = false
        videoPlayIcon.isHidden = true

        contentView.addSubview(imageView)
        contentView.addSubview(videoPlayIcon)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalToConstant: 204),

            videoPlayIcon.widthAnchor.constraint(equalToConstant: 32),
            videoPlayIcon.heightAnchor.constraint(equalToConstant: 32),
            videoPlayIcon.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            videoPlayIcon.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12)

        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeHolder")
        imageView.layer.cornerRadius = 10
        videoPlayIcon.isHidden = true

    }
}
