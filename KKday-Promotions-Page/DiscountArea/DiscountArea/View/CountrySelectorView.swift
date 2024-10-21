

import UIKit

protocol CountrySelectorViewDelegate: AnyObject {
    func didSelectCountry(_ country: Category?)
    func hideCountrySelector()
}

class CountrySelectorView: UIView, UITableViewDelegate, UITableViewDataSource, RadioButtonControllerDelegate {
    
    var countries: [Category] = []
    var selectedCountry: Category?
    weak var delegate: CountrySelectorViewDelegate?
    var radioButtonController: RadioButtonController?
    var separatorLine: UIView?
    
    private var initialFrame: CGRect = .zero
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        
        let handleView = UIView()
        handleView.backgroundColor = UIColor.lightGray
        handleView.layer.cornerRadius = 2.5
        handleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(handleView)
        
        let titleLabel = UILabel()
        titleLabel.text = "目的地"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
       
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)

        separatorLine = UIView()
        separatorLine?.backgroundColor = UIColor.lightGray
        separatorLine?.translatesAutoresizingMaskIntoConstraints = false
        separatorLine?.isHidden = true
        addSubview(separatorLine!)
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RadioButtonTableViewCell.self, forCellReuseIdentifier: "RadioButtonCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 44),
            handleView.heightAnchor.constraint(equalToConstant: 2.5),
            
            headerView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            separatorLine!.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorLine!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorLine!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorLine!.heightAnchor.constraint(equalToConstant: 0.5),
            
            tableView.topAnchor.constraint(equalTo: separatorLine!.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        radioButtonController = RadioButtonController(buttons: [])
        radioButtonController?.delegate = self
    }
    
    func setupPanGesture() {
           panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
           self.addGestureRecognizer(panGestureRecognizer)
       }
   
       @objc func closeButtonTapped() {
           delegate?.hideCountrySelector()
       }
   
       @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
           let translation = gesture.translation(in: self)
           switch gesture.state {
           case .began:
               initialFrame = self.frame
           case .changed:
   
               if translation.y > 0 {
                   self.frame.origin.y = initialFrame.origin.y + translation.y
               }
           case .ended:
   
               if translation.y > 150 {
                   delegate?.hideCountrySelector()
               } else {
   
                   UIView.animate(withDuration: 0.3) {
                       self.frame = self.initialFrame
                   }
               }
           default:
               break
           }
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell", for: indexPath) as? RadioButtonTableViewCell else {
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        let isSelected = country.name == selectedCountry?.name
        cell.configure(with: country.name, selected: isSelected)
        
        cell.selectionStyle = .none
        radioButtonController?.addButton(cell.radioButton)
        
        return cell
    }
    
    func didSelectedButton(_ radioButtonController: RadioButtonController, _ currentSelectedButton: RadioButton?) {
           guard let selectedButton = currentSelectedButton else { return }
           if let index = radioButtonController.buttonArray.firstIndex(of: selectedButton) {
               let selectedCountryData = countries[index]
               if selectedCountryData.name != selectedCountry?.name {
                   selectedCountry = selectedCountryData
               }
               delegate?.didSelectCountry(selectedCountry)
           }
       }
}

extension CountrySelectorView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let firstVisibleIndexPath = (scrollView as? UITableView)?.indexPathsForVisibleRows?.first
        if let row = firstVisibleIndexPath?.row, row > 0 {
            separatorLine?.isHidden = false
        } else {
            separatorLine?.isHidden = true
        }
    }
}

