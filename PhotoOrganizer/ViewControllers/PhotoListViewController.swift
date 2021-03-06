//
//  ViewController.swift
//  PhotoOrganizer
//
//  Created by Rachel Parsons on 6/7/17.
//  Copyright © 2017 Rachel Parsons. All rights reserved.
//

import UIKit
import Photos

class PhotoListViewController: UIViewController {
	
	let PHOTO_DETAIL_SEGUE_IDENTIFIER = "photoDetailSegue"
	let PHOTO_THUMB_CELL_IDENITIFIER = "photoThumbnailCell"
	
	@IBOutlet weak var photosCollectionView: UICollectionView!
	
	var photoAssets: PHFetchResult<PHAsset>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
			switch authorizationStatus {
			case .authorized:
				DispatchQueue.main.async {
					self.loadPhotos()
				}
				break
			default:
				print("fail")
				break
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadPhotos() {
		
		let options = PHFetchOptions()
		options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
		
		photoAssets = PHAsset.fetchAssets(with: .image, options: options)
		
		photosCollectionView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// TODO: file radar for prompt change
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		if segue.identifier == PHOTO_DETAIL_SEGUE_IDENTIFIER {
			if let detailVC = segue.destination as? PhotoDetailsViewController,
				let cell = sender as? UICollectionViewCell,
				let indexPath = photosCollectionView.indexPath(for: cell) {
				detailVC.photoAsset = photoAssets?.object(at: indexPath.row)
			}
		}
	}
}

extension PhotoListViewController: UICollectionViewDelegate {
	
}

extension PhotoListViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let allAssets = photoAssets {
			return allAssets.count
		}
		
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_THUMB_CELL_IDENITIFIER, for: indexPath)
		
		if let asset = photoAssets?.object(at: indexPath.row) {
			let imageManager = PHImageManager.default()
			let size = CGSize(width: 100.0, height: 100.0)
			
			imageManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { (image, nil) in
				if let thumbnail = image,
					let imageView = cell.viewWithTag(123) as? UIImageView {
					
					imageView.image = thumbnail
				}
			})
			
		}
		
		return cell
	}
	
	
}
