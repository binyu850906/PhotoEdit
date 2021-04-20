//
//  MainViewController.swift
//  PhotoEdit
//
//  Created by binyu on 2021/4/17.
//

import UIKit

var imageCollection: Array<UIImage> = []
var selectedCell: PhotoCollectionViewCell? = nil

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewControl: UICollectionView!
    @IBOutlet weak var newButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let fullScreenSize = UIScreen.main.bounds.size
        collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionLayout.itemSize = CGSize(width: fullScreenSize.width/3-10, height: fullScreenSize.height/3-10)
        collectionLayout.minimumLineSpacing = 5
        collectionLayout.scrollDirection = .vertical
        collectionLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 24)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionViewControl.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = imageCollection[indexPath.row]
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        if let editController = storyboard?.instantiateViewController(identifier: "editViewController", creator: { coder in
            EditViewController(coder: coder, editImage: image!)
        }) {
            show(editController, sender: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectPhoto(_ sender: Any) {
    let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
