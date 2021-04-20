//
//  EditViewController.swift
//  PhotoEdit
//
//  Created by binyu on 2021/4/17.
//

import UIKit


enum Mode {
    case rotateMirror, crop, colorControl, photoEffect, textEdit
}
enum ColorControlMode {
    case brightness, contrast, saturation
}

var cropMode: Bool = false
var currentMode: Mode = .rotateMirror
var currentColorControlMode: ColorControlMode = .brightness


class EditViewController: UIViewController {

    var editImage: UIImage
    var editImageView: EditImageUIView?
     
    
    @IBOutlet weak var modeStackView: UIStackView!

    @IBOutlet weak var rotateMirrorBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        editImageView = EditImageUIView(frame: CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW), editImage: editImage)
        view.addSubview(editImageView!)
        
        currentMode = .rotateMirror
        setModeIcon()
        
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, editImage: UIImage) {
        self.editImage = editImage
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModeIcon() {
        
        modeStackView.subviews.forEach{
            ($0 as! UIButton).alpha = 0.3
        }
       
        setRotateMirrorSub(false)
        
        if currentMode == .rotateMirror {
            let rotateMirrorBtn = modeStackView.subviews.first(where: {
                $0.tag == 0
            })
            rotateMirrorBtn?.alpha = 1
            setRotateMirrorSub(true)
        }
        
    }
    
    
    func setRotateMirrorSub(_ bool:Bool) {
        if bool{
            rotateMirrorBottom.constant = 0
        }else{
    rotateMirrorBottom.constant = -56
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: (editImageView?.bounds.size)!)
        let image =  renderer.image { (context) in
            editImageView?.drawHierarchy(in: editImageView!.bounds, afterScreenUpdates: true)
        }
        imageCollection.append(image)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func resetImage(_ sender: Any) {
        
        editImageView?.editInitialize()
    }
    
    @IBAction func rotateRight(_ sender: Any) {
        currentMode = .rotateMirror
        editImageView?.rotate(isPositiveDegree: true)
    }
    
    @IBAction func mirror(_ sender: Any) {
        currentMode = .rotateMirror
        editImageView?.mirror()
    }
    
    @IBAction func setRotateMirrorCropMode(_ sender: Any) {
        
        guard currentMode != .rotateMirror else{ return }
        currentMode = .rotateMirror
        setModeIcon()
    }
    
    @IBAction func crop(_ sender: Any) {
        currentMode = .crop
        guard currentMode != .crop else {
            return
        }
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
