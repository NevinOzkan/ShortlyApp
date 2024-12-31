//
//  OnboardingVC.swift
//  ShortlyApp
//
//  Created by Nevin Özkan on 23.12.2024.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let pages: [UIImage?] = [
        UIImage(named: "Bilgilendirme1"),
        UIImage(named: "Bilgilendirme2"),
        UIImage(named: "Bilgilendirme3")
    ]
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 3
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupPageControl()
    }
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        
        let nib = UINib(nibName: "OnboardingCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OnboardingCell")
    }
    

    @IBAction func skipButton(_ sender: Any) {
        let homeVC = HomeVC()
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        let data = pages[indexPath.row]
        cell.configure(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

