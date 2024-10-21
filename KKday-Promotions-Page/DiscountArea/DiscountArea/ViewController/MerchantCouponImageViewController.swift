
import UIKit

class MerchantCouponImageViewController: UIViewController, UIScrollViewDelegate {
    
    var merchantCoupon: MerchantCoupon?
    var imageUrl: String?
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupImageView()
        setupNavigationBar()
        
        if let imageUrl = URL(string: merchantCoupon?.imageUrl ?? "") {
            self.imageView.loadImage(from: imageUrl) { [weak self] image in
                self?.updateImageViewHeight(for: image)
            }
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
            
        ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func updateImageViewHeight(for image: UIImage?) {
            guard let image = image else { return }
            
            let aspectRatio = image.size.height / image.size.width
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
            ])
            
            view.layoutIfNeeded()
        }
    
    private func setupNavigationBar() {
        
        self.title = merchantCoupon?.title
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = .gray
        
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadTapped))
        downloadButton.tintColor = .gray
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shareButton.tintColor = .gray
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [downloadButton, shareButton]
    }
    
    @objc private func backTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func downloadTapped() {
        
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        let alert = UIAlertController(title: "下載完成", message: "圖片已保存到相簿", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func shareTapped() {
        
        guard let image = imageView.image else { return }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
}
