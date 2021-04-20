//
//  editImageUIView.swift
//  PhotoEdit
//
//  Created by binyu on 2021/4/17.
//

import UIKit
import CoreImage

var editStatus = EditStatus()
class EditImageUIView: UIView {

    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }
    
    static var edgeSize: CGFloat = 44.0
    private typealias `Self` = EditImageUIView
    
    
    let screenW = UIScreen.main.bounds.width
    let screenH = UIScreen.main.bounds.height
    let imageInitW: CGFloat
    let imageInitH: CGFloat
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    var imageView = UIImageView()
    
    var isMirrored: Bool = false
    var rotateCounts: Int = 0

    init?(frame: CGRect, editImage: UIImage) {

        self.imageInitW = editImage.size.width
        self.imageInitH = editImage.size.height
        super.init(frame: frame)
        
        imageView.image = editImage
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        editInitialize()
        self.addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editInitialize() {
        self.frame = CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW)
        imageView.frame.size = CGSize(width: screenW, height: (screenW*imageInitH)/imageInitW)
        imageView.frame.origin = CGPoint(x: (screenW-imageView.frame.width)/2, y:(screenW-imageView.frame.height)/2)
        
        if editStatus.isMirrored {
            self.mirror()
        }
        if editStatus.rotateCounts % 4 != 0 {
            editStatus.rotateCounts = 0
            self.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        
        
    }
    
    func mirror() {
        if !editStatus.isMirrored {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        editStatus.isMirrored = !editStatus.isMirrored
    }
    
    func rotate(isPositiveDegree: Bool) {
        if isPositiveDegree{
            self.rotateCounts += 1
        } else{
            self.rotateCounts -= 1
        }
        imageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(self.rotateCounts))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentMode == .crop else {
            return
        }
        if let touch = touches.first {
            touchStart = touch.location(in: self)
            currentEdge = {
                if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomRight
                } else if touchStart.x < Self.edgeSize && touchStart
                            .y < Self.edgeSize{
                    return .topLeft
                } else if self.bounds.size.width - touchStart.x < Self.edgeSize &&
                            touchStart.y < Self.edgeSize{
                    return .topRight
                } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize{
                    return .bottomLeft
                }
                return .none
            }()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentMode == .crop else {
            return
        }
        if let touch = touches.first{
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y
            
            switch currentEdge {
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaWidth, width: width - deltaWidth, height: height - deltaWidth)
                imageView.frame.origin.x -= deltaWidth
                imageView.frame.origin.y -= deltaHeight
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
                imageView.frame.origin.y -= deltaHeight
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaHeight)
           
            default:
                break
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        currentEdge = .none
        if (self.frame.width > UIScreen.main.bounds.width) {
            self.frame.size.width = UIScreen.main.bounds.width
        }
        if (self.frame.height > UIScreen.main.bounds.height) {
            self.frame.size.height = UIScreen.main.bounds.height
        }
        self.frame.origin.x = (screenW - self.frame.width)/2
        self.frame.origin.y = (screenH - self.frame.height)/2
       }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
