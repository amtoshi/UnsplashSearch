//
//  ViewController.swift
//  imageTestConcurrency
//
//  Created by Ashutosh Mane on 08/08/22.
//

import UIKit
import Lottie


class PhotosCollectionViewController: UIViewController {
    
    
    
    private var currentKeyword:String?
    var searchResource:ImageSearchResource?
    var searchRequest: ImageSearchRequest<ImageSearchResource>?
    //MARK: Custom queue
    let concurrentCustomQueue = DispatchQueue(label: "ConcurrentCustomQueue", qos: .userInteractive, attributes: .concurrent)
    
   
    var currentPageCounter:Int=0
    
    var model:Wrapper<Image> = Wrapper(){
        
        didSet{
            
            if self.model.results.count != 0 {
                pagination()
                collectionView.reloadData()
                layoutSwitcherButton.isHidden = false
            }
            else {
                layoutSwitcherButton.isHidden = true
            }
            
            
        }
    }
    
    var layoutMode:Layout = .medium
    
   
    
    //MARK: UI Elements and outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    @usesAutoLayout var lottieAnimation:AnimationView = {
        let view = AnimationView()
        view.contentMode = .scaleAspectFit
        let animation=Animation.named("ImagePreloader")
        view.animation=animation
        view.loopMode = .loop
        return view
        
    }()
    
    @usesAutoLayout var searchImageLabel:UILabel = {
        var view = UILabel()
        view.text = "Tap the search button and get going!"
        view.font = Design.Fonts.Body
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 2
        view.textAlignment = .center
        view.textColor = Design.Color.jetGrey
        return view
    }()
    
    @usesAutoLayout var imageSearchbar:UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.searchTextField.backgroundColor = .white
        bar.isHidden = true
        return bar
    }()
    
    @usesAutoLayout var layoutSwitcherButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.mediumLayout, for: .normal)
        view.addTarget(self, action: #selector(layoutSwitcherClicked), for: .touchUpInside)
        view.tintColor = Design.Color.crayolaBlue
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var searchButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.searchIcon, for: .normal)
        view.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
        view.tintColor = Design.Color.orangeWeb
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var collectionButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.collectionIcon, for: .normal)
        view.addTarget(self, action: #selector(homeClicked), for: .touchUpInside)
        view.tintColor = Design.Color.orangeWeb
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var nextButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.nextIcon, for: .normal)
        view.tintColor = Design.Color.crayolaBlue
        view.addTarget(self,
                       action: #selector(nextClicked),
                       for: .touchUpInside)
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var previousButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.previousIcon, for: .normal)
        view.tintColor = Design.Color.crayolaBlue
        view.addTarget(self,
                       action: #selector(previousClicked),
                       for: .touchUpInside)
        view.addShadow()
        
        return view
    }()
    
    
    @usesAutoLayout var bottomStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.spacing = 30.0
        return view
    }()
    
    
    @usesAutoLayout var topStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 30.0
        view.distribution = .equalCentering
        return view
    }()
    
    @usesAutoLayout var animationStackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        
        return view
    }()
    
    //MARK: Target actions
   
    
    @objc func searchClicked(){
    #warning("implement animation")
        showSearchBar()
        
    }
    
    @objc func homeClicked(){
        loadHomepage()
    }
    
    @objc func nextClicked(){
        print("clicked1")
        nextPage()
      
        
    }
    
    @objc func previousClicked(){
        print("clicked2")
        previousPage()
        
    }
    
    @objc func layoutSwitcherClicked(){
        switchLayout()
    }
    
    //MARK: viewDidLoad
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        view.addSubview(imageSearchbar)
        view.addSubview(bottomStackView)
        view.addSubview(animationStackView)
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(collectionButton)
        topStackView.addArrangedSubview(searchButton)
        bottomStackView.addArrangedSubview(previousButton)
        bottomStackView.addArrangedSubview(layoutSwitcherButton)
        bottomStackView.addArrangedSubview(nextButton)
        animationStackView.addArrangedSubview(lottieAnimation)
        animationStackView.addArrangedSubview(searchImageLabel)
        layoutSwitcherButton.isHidden = true
        previousButton.isHidden = true
        nextButton.isHidden = true
        imageSearchbar.delegate = self
        lottieAnimation.play()
        
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier)
        
    }
    
    
    fileprivate func layout(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageSearchbar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageSearchbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSearchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            animationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animationStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            collectionView.topAnchor.constraint(equalTo:  view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lottieAnimation.heightAnchor.constraint(equalTo: animationStackView.heightAnchor, multiplier: 0.8),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7.0)
            
        ])
    }
    
    fileprivate func showSearchBar() {
        if self.imageSearchbar.isHidden {
            self.imageSearchbar.isHidden = false
            self.imageSearchbar.becomeFirstResponder()
            self.searchButton.setImage(Design.Images.cancelIcon, for: .normal)
            self.animationStackView.isHidden = true
            
        }
        else {
            self.imageSearchbar.resignFirstResponder()
            self.imageSearchbar.isHidden = true
            self.searchButton.setImage(Design.Images.searchIcon, for: .normal)
            self.animationStackView.isHidden = false
        }
    }
    
    fileprivate func pagination() {
         var numberOfPages = self.model.totalPages + 1
         if numberOfPages == 1{
             self.previousButton.isHidden = true
             self.nextButton.isHidden = true
         }
         if numberOfPages > 1 && currentPageCounter == 1 {
             self.previousButton.isHidden = true
             self.nextButton.isHidden = false
         }
         else{
             self.previousButton.isHidden = false
             self.nextButton.isHidden = false
         }
         if currentPageCounter == numberOfPages{
             self.nextButton.isHidden = true
             self.previousButton.isHidden = false
         }
     }
     
    
    fileprivate func loadHomepage(){
        
    }
    
    fileprivate func nextPage(){
        guard let resource  = searchResource, let request = searchRequest else {
            return
        }
        resource.nextPage()
        print(resource.page!)
        request.resource = resource
        request.execute { result in
            switch result{
                case .success(let imageWrapper):
                    guard let imageWrapper = imageWrapper  else{
                        return
                    }
                    self.model.results = imageWrapper.results
                case .failure(let error):
                    print(error)
                    
            }
        }
    }
    
    fileprivate func previousPage(){
        guard let resource  = searchResource, let request = searchRequest else {
            return
        }
        resource.previousPage()
        print(resource.page!)
        request.resource = resource
        request.execute { result in
            switch result{
                case .success(let imageWrapper):
                    guard let imageWrapper = imageWrapper  else{
                        return
                    }
                    self.model.results = imageWrapper.results
                case .failure(let error):
                    print(error)
                    
            }
        }
        
    }
    
    fileprivate func switchLayout(){
        flowLayout.invalidateLayout()
        flowLayout.prepare()
        switch layoutMode{
            case .small:
                layoutMode = .medium
                self.layoutSwitcherButton.setImage(Design.Images.mediumLayout, for: .normal)
            case .medium:
                layoutMode = .large
                self.layoutSwitcherButton.setImage(Design.Images.largeLayout, for: .normal)
            case .large:
                layoutMode = .small
                self.layoutSwitcherButton.setImage(Design.Images.smallLayout, for: .normal)
        }
    
        
    }
    
    fileprivate func searchImages(with keyword:String){
        
        currentKeyword = keyword
        
        self.searchResource = ImageSearchResource(with: keyword, onPage: nil)
        print(keyword)
        self.searchRequest = ImageSearchRequest<ImageSearchResource>( for: searchResource!)
        searchRequest!.execute { result in
            switch result{
                case .success(let imageWrapper):
                    guard var imageWrapper = imageWrapper  else{
                        return
                    }
                    imageWrapper.searchTerm = keyword
                    self.model = imageWrapper
                case .failure(let error):
                    print(error)
                    
            }
        }
        
    }
}





extension PhotosCollectionViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
        guard let  searchString = searchBar.searchTextField.text
        else { return }
        self.searchImages(with: searchString)
        searchBar.endEditing(true)
    }
    
    
    
    
    
}
//MARK: CollectionView Delegate & DataSource
extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.results.count
    }
    //ios academy video- registering cell seems to be the key
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PhotosCollectionViewCell()
         collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath)
        
        
        // Configure the cell
        concurrentCustomQueue.async {
            guard let imageURL = URL(string: self.model.results[indexPath.row].imageURL.small), let likes = self.model.results[indexPath.row].likes
            else{
                print("imageURL issue")
                return
            }
            if let imageData = try? Data.init(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.likesLabel.text  = String(likes)
                    
                }
                
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = model.results[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailViewController = storyboard.instantiateViewController(identifier: "PhotoDetail") { coder in
            let detailViewController = PhotoDetailViewController(coder: coder, with: image, title: self.model.searchTerm!)
            return detailViewController
        }
        detailViewController.modalPresentationStyle  = .fullScreen
        present(detailViewController, animated: true)
        
        
    }
    
}

