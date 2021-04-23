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
    @IBOutlet weak var colorControlBottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var colorControlBottomStackView: UIStackView!
    @IBOutlet weak var colorContorlLabel: UILabel!
    @IBOutlet weak var colorControlSlider: UISlider!
    
    @IBOutlet weak var effectScrollView: UIScrollView!
    @IBOutlet weak var effectScrollContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        editImageView = EditImageUIView(frame: CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW), editImage: editImage)
        view.addSubview(editImageView!)
        
        currentMode = .rotateMirror
        editImageView?.editInitialize()
        refreshViews()
        
        let defaultEffectView = PhotoEffectUIView(frame: CGRect(x: 12, y: 12, width: 114, height: 82), effectType: nil)
        
        effectScrollContentView.addSubview(defaultEffectView)
        for (index, type) in PhotoEffect.allCases.enumerated() {
            let beginnerX = 12
            let frame = CGRect(x: beginnerX+(index+1)*126, y: 12, width: 114, height: 82)
            let effectUIView = PhotoEffectUIView(frame: frame, effectType: type)
            effectScrollContentView.addSubview(effectUIView)
        }
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: Notification.Name(rawValue: "refreshViews"), object: nil)
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
    
        setSubFeatureViewConstraint(targetConstraint: rotateMirrorBottom, value: -300)
        setSubFeatureViewConstraint(targetConstraint: colorControlBottom, value: -250)
        setSubFeatureViewOrigin(targetView: effectScrollView, Value: 800)
        
        
        if currentMode == .rotateMirror {
            setIconActive(stackView: modeStackView, index: 0)
            setSubFeatureViewConstraint(targetConstraint: rotateMirrorBottom, value: 0)
            
        } else if currentMode == .colorControl {
            setIconActive(stackView: modeStackView, index: 1)
            setSubFeatureViewConstraint(targetConstraint: colorControlBottom, value: 0)
            setColorControlSub()
        } else if currentMode == .photoEffect {
            setIconActive(stackView: modeStackView, index: 2)
            setSubFeatureViewOrigin(targetView: effectScrollView, Value: 680
            )
        } else if currentMode == .textEdit {
            setIconActive(stackView: modeStackView, index: 3)
        }
        
    }
    
    @objc func refreshViews() {
        setModeIcon()
        setColorControlSub()
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
    
    func setColorControlSub() {
        let status = editStatus.colorControls
        colorControlBottomStackView.subviews.forEach {
            ($0 as! UIButton).alpha = 0.3
        }
        if currentColorControlMode == .brightness{
            setIconActive(stackView: colorControlBottomStackView, index: 0)
            colorContorlLabel.text = "Brightness"
            colorControlSlider.minimumValue = -0.5
            colorControlSlider.maximumValue = 0.5
            colorControlSlider.setValue(status[0].value, animated: true)
        } else if currentColorControlMode == .contrast {
            setIconActive(stackView: colorControlBottomStackView, index: 1)
            colorContorlLabel.text = "contrast"
            colorControlSlider.minimumValue = 0
            colorControlSlider.maximumValue = 2
            colorControlSlider.setValue(status[1].value, animated: true)
        } else if currentColorControlMode == .saturation {
            setIconActive(stackView: colorControlBottomStackView, index: 2)
            colorContorlLabel.text = "saturation"
            colorControlSlider.minimumValue = 0
            colorControlSlider.maximumValue = 2
            colorControlSlider.setValue(status[2].value, animated: true)
        }
    }
    
    //顯示主功能
    func setIconActive(stackView: UIStackView, index: Int) {
        let icon = stackView.subviews.first(where: {
            $0.tag == index
        })
        icon?.alpha = 1
    }
    func setSubFeatureViewConstraint(targetConstraint: NSLayoutConstraint, value: CGFloat) {
        targetConstraint.constant = value
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func setSubFeatureViewOrigin(targetView: UIView, Value: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            targetView.frame.origin.y = Value
        }
    }
    
    
   /* override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }*/
    
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
    @IBAction func setPhotoEffectMode(_ sender: Any) {
        guard currentMode != .photoEffect else {
            return
        }
        currentMode = .photoEffect
        setModeIcon()
    }
    @IBAction func setColorControlMode(_ sender: Any) {
        guard currentMode != .colorControl else {
            return
        }
        currentMode = .colorControl
        setModeIcon()
    }
    
    
    @IBAction func setBrightnessMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .brightness else {
            return
        }
        currentColorControlMode = .brightness
        setColorControlSub()
    }
    
    @IBAction func setContrastMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .contrast else {
            return
        }
        currentColorControlMode = .contrast
        setColorControlSub()
    }
    
    @IBAction func setSaturationMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .saturation else {
            return
        }
        currentColorControlMode = .saturation
        setColorControlSub()
    }
    
    @IBAction func sliderColorControl(_ sender: UISlider) {
        guard currentMode == .colorControl else {
            return
        }
        switch currentColorControlMode {
        case .brightness:
            editStatus.colorControls[0].value = sender.value
        case .contrast:
            editStatus.colorControls[1].value = sender.value
        case .saturation:
            editStatus.colorControls[2].value = sender.value
        }
        
        editImageView?.useFilter()
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
