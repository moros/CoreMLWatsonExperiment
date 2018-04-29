//
//  ViewController.swift
//  CoreMLWatsonExperiment
//
//  Created by Doug Mason on 4/29/18.
//  Copyright © 2018 Doug Mason. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let apiKey = "f197de9a758a49313b7e35b42c0b2489192aa168"
    let version = "2018-04-29"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("There was an error picking the image.")
            return
        }
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        visualRecognition.classify(image: image) { (classifiedImages) in
            var classificationResults : [String] = []
            let classes = classifiedImages.images.first!.classifiers.first!.classes
            for index in 0..<classes.count {
                classificationResults.append(classes[index].className)
            }
            
            print(classificationResults)
            if classificationResults.contains("hotdog") {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                    self.topBarImageView.image = UIImage(named: "hotdog")
                }
            }
            else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Not hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                    self.navigationController?.navigationBar.isTranslucent = false
                    self.topBarImageView.image = UIImage(named: "not-hotdog")
                }
            }
            
            DispatchQueue.main.async {
                self.cameraButton.isEnabled = true
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem)
    {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
}
