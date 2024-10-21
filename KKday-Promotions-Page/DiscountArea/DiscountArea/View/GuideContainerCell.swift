

import Foundation
import UIKit

class GuideContainerCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var guideList: [Guide] = [] {
        didSet{
            guideCollectionView.reloadData()
            pageControl.numberOfPages = guideList.count
            guideCollectionView.layoutIfNeeded()
        }
    }

    var backgroundImageView = UIImageView()

    var guideCollectionView: UICollectionView!
    var pageControl: UIPageControl!

    let cellIdentifier = "guideCell"

    var timer: Timer?

    var currentIndex = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackground()
        setUpGuideCollectionView()
        setupPageControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guideCollectionView.frame = contentView.bounds
    }

    func setupBackground() {
        backgroundImageView.image = UIImage(named: "guide_background")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }

    func setUpGuideCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        guideCollectionView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
        guideCollectionView.backgroundColor = .clear
        guideCollectionView.delegate = self
        guideCollectionView.dataSource = self
        guideCollectionView.showsHorizontalScrollIndicator = false

        guideCollectionView.register(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        contentView.addSubview(guideCollectionView)

        guideCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            guideCollectionView.heightAnchor.constraint(equalToConstant: 252),
            guideCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            guideCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            guideCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        pageControl.currentPage = 0
    }

    @objc func pageControlChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let offset = CGFloat(currentPage) * 320.0
        guideCollectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guideList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = guideCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCell
        let guide = guideList[indexPath.item]
        cell.imageView.loadImage(from: guide.imageUrl)

        if guide.isShowVideoPlayIcon == true{
            cell.videoPlayIcon.isHidden = false
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let guide = guideList[indexPath.item]
        open(urlString: guide.link)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 320.0, height: collectionView.frame.height)

    }

    func configure(with guide: [Guide]){
        self.guideList = guide
    }

    func startAutoScrollTimer() {
        guideCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        currentIndex = 0
        pageControl.currentPage = 0

        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }

    @objc func autoScroll() {
        
        guard let collectionView = guideCollectionView else { return }

        let totalItems = guideList.count

        let nextItem = (currentIndex + 1) % totalItems

        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        pageControl.currentPage = nextItem

        let targetOffset = CGPoint(x: CGFloat(nextItem) * 320.0 , y: 0)

        if nextIndexPath.item == 0{
            collectionView.setContentOffset(targetOffset, animated: false)
        } else {
            collectionView.setContentOffset(targetOffset, animated: true)
        }

        currentIndex += 1

    }

    func stopAutoScrollTimer() {
        timer?.invalidate()
        timer = nil
    }
}
