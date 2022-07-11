//
//  OnboardingVC.swift
//  FarmEats
//
//  Created by CSPrasad on 08/07/22.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    ///Empty array of OnboardingSlide Data model
    var slides: [OnboardingSlide] = []
    
    ///Current page count and updating button data as well.
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            self.view.backgroundColor = slides[currentPage].color
            self.nextBtn.backgroundColor = slides[currentPage].color
//            if currentPage == slides.count - 1 {
//                nextBtn.setTitle("Join the movement!", for: .normal)
//            } else {
//                nextBtn.setTitle("Join the movement!", for: .normal)
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Appending data to empty slides array.
        ///and adding total page count and button shadow as well.
        slides = [
            OnboardingSlide(title: "Quality", description: "Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain.",color: #colorLiteral(red: 0.368627451, green: 0.6352941176, blue: 0.3725490196, alpha: 1), image: #imageLiteral(resourceName: "Slide-1")),
            OnboardingSlide(title: "Convenient", description: "Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.",color: #colorLiteral(red: 0.8352941176, green: 0.4431372549, blue: 0.3568627451, alpha: 1), image: #imageLiteral(resourceName: "Slide-2")),
            OnboardingSlide(title: "Local", description: "We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time.",color: #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.4117647059, alpha: 1), image: #imageLiteral(resourceName: "Slide-3"))
        ]
        pageControl.numberOfPages = slides.count
    }
    
    
    ///Next button Action based on conditon
    ///if current page = last slide then it will take to landing login page. if not last page then it will go to next slide.
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(identifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            UserDefaults.standard.hasOnboarded = true
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

///Extension for collectionview delegate and data source.
extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVCell.identifier, for: indexPath) as! OnboardingCVCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

