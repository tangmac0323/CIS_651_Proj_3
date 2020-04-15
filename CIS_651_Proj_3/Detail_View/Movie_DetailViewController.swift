//
//  Movie_DetailViewController.swift
//  CIS_651_Proj_3
//
//  Created by Mengtao Tang on 2/26/20.
//  Copyright © 2020 Mengtao Tang. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController, CAAnimationDelegate{
    
    @IBOutlet weak var MovieImageCollectionView: UICollectionView!
    @IBOutlet weak var MovieTitle_Label: UILabel!
    @IBOutlet weak var ReleaseDate_Label: UILabel!
    @IBOutlet weak var GnereTag_Label: UILabel!
    @IBOutlet weak var GenresList_Label: UILabel!
    @IBOutlet weak var OverviewTag_Label: UILabel!
    @IBOutlet weak var Overview_TextField: UITextView!
    @IBOutlet weak var Rating_View: RatingView!
    
    @IBOutlet weak var Rating_Portrait_X: NSLayoutConstraint!
    @IBOutlet weak var Rating_Landscape_X: NSLayoutConstraint!
    @IBOutlet weak var Rating_Portrait_Y: NSLayoutConstraint!
    @IBOutlet weak var Rating_Landscape_Y: NSLayoutConstraint!
    
    
    
    var movieId:Int = 0
    var tmdbDetailModel: MovieDetailCVModel?
    var imageList: [String] = []        // store the image that will be posted in collection view
    var ratingVal: Float = 0
    var shapeLayer: CAShapeLayer?
       
    override func viewWillAppear(_ animated: Bool) {
        //self.view.layer.allowsGroupOpacity = true
        //self.view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        MovieImageCollectionView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        MovieTitle_Label.backgroundColor = UIColor(white: 1, alpha: 0.0)
        ReleaseDate_Label.backgroundColor = UIColor(white: 1, alpha: 0.0)
        GnereTag_Label.backgroundColor = UIColor(white: 1, alpha: 0.0)
        GenresList_Label.backgroundColor = UIColor(white: 1, alpha: 0.0)
        Overview_TextField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        Rating_View.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.shapeLayer?.frame = self.Rating_View.bounds
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(movieId)
        //MovieImageCollectionView.heightAnchor.constraint(equalTo: MovieImageCollectionView.widthAnchor, multiplier: 0.5)
        //MovieTitle_Label.text = String(self.movieId)
        
        //self.MovieImageCollectionView.automaticallyAdjustsScrollViewInsets = NO;
        
        MovieImageCollectionView.delegate = self
        MovieImageCollectionView.dataSource = self
        
        self.tmdbDetailModel = MovieDetailCVModel(viewLink: MovieImageCollectionView, movieId: self.movieId)
        
        /*
        if let flowLayout = MovieImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
          flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        */
        
        self.tmdbDetailModel?.download_MovieDetail {
            
            // display title
            self.MovieTitle_Label.text = self.tmdbDetailModel?.detailResult?.title
            
            // display release date
            self.ReleaseDate_Label.text = self.tmdbDetailModel?.detailResult?.release_date
            
            // display generes
            self.GenresList_Label.text = self.tmdbDetailModel?.constructGenresStr(genres: (self.tmdbDetailModel?.detailResult!.genres)!)
            
            //print(self.tmdbDetailModel?.detailResult?.genres[0].name)
            
            // display overview
            self.Overview_TextField.text = self.tmdbDetailModel?.detailResult?.overview
            
            self.ratingVal = self.tmdbDetailModel?.detailResult?.vote_average ?? 0.0
            
            self.setupRatingView(rating: self.ratingVal)
            
            self.tmdbDetailModel?.download_ImageList {
                // do nothing
                print("Image List download completed")
                
                /*
                for backdrop in (self.tmdbDetailModel?.imageResults?.backdrops)!{
                    print(backdrop.file_path as Any)
                }
                */
                self.imageList = self.tmdbDetailModel?.generateImageList() ?? []
                //print(self.imageList)
                
                            // reload the view
                print("Reload Collection View")
                self.MovieImageCollectionView.reloadData()
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // function to setup the CAAnimation based circular progress bar
    // to indicate the rating of a the movie
    func setupRatingView(rating: Float){
        
        self.shapeLayer = CAShapeLayer()
        
        //let ratingViewCenter = self.Rating_View.center
        //let layer_x = viewCenter.x - 30
        //let layer_y = viewCenter.y - 30
        
        //print("\(layer_x), \(layer_y)")
        
        // **************************
        // USE RELATIVE COORDS HERE
        // **************************
        let ratingViewCenter = CGPoint(x: 30,y: 30)
        
        
        let animationDuration: CFTimeInterval = 0.8
        
        let startingAngle = -CGFloat.pi / 2
        let endingAngle = CGFloat(rating) * 2 * CGFloat.pi / 10 - CGFloat.pi / 2
        
        let circularPath = UIBezierPath(arcCenter: ratingViewCenter, radius: 28, startAngle: startingAngle, endAngle: endingAngle, clockwise: true)
        
        //self.shapeLayer?.backgroundColor = UIColor.black.cgColor
        // animate the circle
        self.shapeLayer?.path = circularPath.cgPath
        
        self.shapeLayer?.strokeColor = UIColor.green.cgColor
        self.shapeLayer?.lineWidth = 8
        self.shapeLayer?.fillColor = UIColor.clear.cgColor
        
        self.shapeLayer?.lineCap = CAShapeLayerLineCap.round
        
        self.shapeLayer?.strokeEnd = 0
        
        //self.shapeLayer?.frame = CGRect(x: layer_x, y: layer_y, width: 70, height: 70)
        
        
        //view.layer.addSublayer(self.shapeLayer!)
        self.Rating_View.layer.addSublayer(self.shapeLayer!)
        
        
        //print("Layer: \(self.shapeLayer?.frame)")
        //self.shapeLayer?.frame = CGRect(x: layer_x, y: layer_y, width: 35, height: 35)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.delegate = self
        //basicAnimation.fromValue = 0.0
        basicAnimation.toValue = 1
        //basicAnimation.beginTime = 0
        basicAnimation.duration = CFTimeInterval(animationDuration)
        //basicAnimation.isAdditive = true
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        /*
        // animate the color
        let colourAnimation = CABasicAnimation()
        colourAnimation.keyPath = #keyPath(CAShapeLayer.strokeColor)
        colourAnimation.fromValue = UIColor.red.cgColor
        colourAnimation.toValue = UIColor.green.cgColor
        colourAnimation.beginTime = CFTimeInterval(6 / rating * Float(animationDuration))  // change colour when aboving 6.0 rating
        colourAnimation.duration = 0.0001
        colourAnimation.isAdditive = true
        colourAnimation.fillMode = .forwards
        colourAnimation.isRemovedOnCompletion = false
        
        // make the animation group
        let progressAndColourAnimation = CAAnimationGroup()
        progressAndColourAnimation.animations = [basicAnimation, colourAnimation]
        progressAndColourAnimation.duration = CFTimeInterval(animationDuration)
        //progressAndColourAnimation.isRemovedOnCompletion = false
        shapeLayer.add(progressAndColourAnimation, forKey: "ratingAnimation")
        */
        self.shapeLayer?.add(basicAnimation, forKey: "ratingAnimation")
        //print("steup done")
    }
    
    // CAAnimation Delegate
    // show the percentage of the rating value
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation done")
        let viewCenter = self.Rating_View.center
        let ratingLabel = UILabel.init()
        ratingLabel.text = "\(Int(self.ratingVal*10))%"
        ratingLabel.font = UIFont(name: "verdana-bold", size: 10)
        ratingLabel.frame = CGRect(x: viewCenter.x - 30, y: viewCenter.y - 20, width: 40, height:20)
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .yellow
        self.view.addSubview(ratingLabel)
    }
    
    
    /*
    func addRatingText(){
        let viewCenter = self.Rating_View.center
        let ratingLabel = UILabel.init()
        ratingLabel.text = "\(Int(self.ratingVal*10))%"
        ratingLabel.font = UIFont(name: "verdana-bold", size: 10)
        ratingLabel.frame = CGRect(x: viewCenter.x-20, y: viewCenter.y-10, width: 40, height:20)
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .yellow
        self.view.addSubview(ratingLabel)
    }
 */
    
    /*
    @objc private func displayRatingView(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "ratingAnimation")
    }
 */
    
    // i still cannot figure out the reason why the rating is at the wrong position
    /*
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIDevice.current.orientation.isLandscape {
                // activate landscape changes
                print("Landscape:")
                print("--- Coords: \(self.Rating_View.center)")
                //self.view.layer.sublayers?.popLast()
                //self.shapeLayer?.removeAllAnimations()
                //self.shapeLayer?.removeFromSuperlayer()
                //self.shapeLayer?.path = nil
                //self.setupRatingView(rating: self.ratingVal)
                //self.Rating_View.center = CGPoint(x: 600, y: 70)
                
                //self.shapeLayer?.isHidden = true
            } else {
                print("Portrait:")
                print("--- Coords: \(self.Rating_View.center)")
                // activate portrait changes
                                //self.view.layer.sublayers?.popLast()
                //self.shapeLayer?.removeAllAnimations()
                //self.shapeLayer?.removeFromSuperlayer()
                //self.shapeLayer?.path = nil
                //self.setupRatingView(rating: self.ratingVal)
                //self.shapeLayer?.isHidden = true
            }
        })
    }
    */
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /*
        if UIDevice.current.orientation.isLandscape {
            print("Landscape:")
            self.shapeLayer?.removeAllAnimations()
            self.shapeLayer?.removeFromSuperlayer()
            self.shapeLayer?.path = nil
            //self.Rating_View.topAnchor.constraint(equalToSystemSpacingBelow: self.Rating_View.topAnchor, multiplier: )
            self.Rating_Landscape_X.constant = -50
            self.Rating_Landscape_Y.constant = 50
            
            self.setupRatingView(rating: self.ratingVal)
            print("--- Coords: \(self.Rating_View.center)")
        }
        else{
            print("Portait:")
            self.shapeLayer?.removeAllAnimations()
            self.shapeLayer?.removeFromSuperlayer()
            self.shapeLayer?.path = nil
            
            self.Rating_Portrait_X.constant = -50
            self.Rating_Portrait_Y.constant = 75
            
            self.setupRatingView(rating: self.ratingVal)
            print("--- Coords: \(self.Rating_View.center)")
        }
        */
        
        //self.MovieImageCollectionView?.collectionViewLayout.invalidateLayout();
    }
 
    
}


// ectension of ui view controller
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MovieImageCollectionView.frame.width/1.5, height: MovieImageCollectionView.frame.height/1.01)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == MovieImageCollectionView){
            return self.imageList.count
        }
        return 0
    }
    
    // display content of collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MovieImageCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCVCell", for: indexPath) as! MovieDetailCollectionViewCell
        //cell.backgroundColor = .red
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        //cell.MovieDetailImage.backgroundColor = UIColor(white: 1, alpha: 0.0)
        let image_path  = self.imageList[indexPath.row]
        
        //print("Add\(image_path) to collection view")
        
        self.tmdbDetailModel?.download_Image(from: image_path, imageView: cell.MovieDetailImage, category: "POSTER")
        
        //print(cell.MovieDetailImage.intrinsicContentSize)
        
        return cell
    }
    
    // function to set the insect of the view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
}
