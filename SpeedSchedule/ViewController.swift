//
//  ViewController.swift
//  SpeedSchedule
//
//  Created by Rolf Locher on 1/22/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import SpriteKit
import Intents


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var mainBlurView: UIVisualEffectView!
    
    @IBOutlet var mainButtonsView: UIView!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var uploadButton: UIButton!
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum;
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet var sourceButton: UIButton!
    
    @IBAction func sourceButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://github.com/rolflocher/FastSchedule") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet var settingsButton: UIButton!
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.mainButtonsView.isHidden=true
        self.mainBlurView.isUserInteractionEnabled = true
        
        self.aboutButton.isHidden=false
        self.heightButton.isHidden=false
        self.cropButton.isHidden=false
        self.notificationsButton.isHidden=false
    }
    
    @IBOutlet var aboutButton: UIButton!
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        self.aboutButton.isHidden=true
        self.heightButton.isHidden=true
        self.cropButton.isHidden=true
        self.notificationsButton.isHidden=true
        
        self.aboutTextView.isHidden=false
        self.donateButton.isHidden=false
        
        let settingsTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(aboutTapPressed))
        self.aboutTextView.addGestureRecognizer(settingsTapPressRecognizer)
        self.aboutTextView.isUserInteractionEnabled = true
    }
    
    @IBOutlet var heightButton: UIButton!
    
    @IBAction func heightButtonPressed(_ sender: Any) {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Hey, Siri!")
            } else {
                print("Nay, Siri!")
            }
        }
        let intent = WhatClassIntent()
        
        intent.suggestedInvocationPhrase = "What is my next class"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print(error)
                } else {
                    print("successful donate")
                }
            }
        }
    }
    
    @IBOutlet var cropButton: UIButton!
    
    @IBAction func cropButtonPressed(_ sender: Any) {
        guard let url = URL(string: "http://www.speedschedule.net") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet var notificationsButton: UIButton!
    
    @IBAction func notificationsButtonPressed(_ sender: Any) {
        print("notification button pressed")
    }
    
    @IBOutlet var aboutTextView: UITextView!
    
    @IBOutlet var donateButton: UIButton!
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://www.paypal.me/rolfspaypal") else { return }
        UIApplication.shared.open(url)
    }
    
//        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
//            if userDefaults.data(forKey: "schedule1") != nil {
//                let scheduleImage = UIImage(data:userDefaults.data(forKey: "schedule1")!)
//                self.mainImageView.image = scheduleImage
//            }
//            else {
//                self.mainImageView.image = UIImage(named: "DefaultSchedule")
//            }
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomImage()
        self.mainBlurView.layer.cornerRadius = 10.0
        self.mainBlurView.clipsToBounds = true
        
        let settingsTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsTapPressed))
        self.mainBlurView.addGestureRecognizer(settingsTapPressRecognizer)
        self.mainBlurView.isUserInteractionEnabled = true
        
        self.aboutButton.isHidden=true
        self.heightButton.isHidden=true
        self.cropButton.isHidden=true
        self.notificationsButton.isHidden=true
        
        self.aboutTextView.isHidden=true
        self.aboutTextView.isEditable=false
        self.donateButton.isHidden=true
        
    }
    
    @objc func settingsTapPressed(sender: UITapGestureRecognizer) {
        
        if self.notificationsButton.isHidden == false {
            self.mainButtonsView.isHidden=false
            self.mainBlurView.isUserInteractionEnabled=false
            
            self.aboutButton.isHidden=true
            self.heightButton.isHidden=true
            self.cropButton.isHidden=true
            self.notificationsButton.isHidden=true
        }
        
    }
    
    @objc func aboutTapPressed(sender: UITapGestureRecognizer) {
        self.aboutTextView.isHidden=true
        self.donateButton.isHidden=true
        
        self.aboutButton.isHidden=false
        self.heightButton.isHidden=false
        self.cropButton.isHidden=false
        self.notificationsButton.isHidden=false
    }

    func getRandomImage () {
        
        let session = URLSession(configuration: .default)
        //let imageURL = URL(string: "https://picsum.photos/375/667/?random")!
        let imageURL = URL(string: "https://picsum.photos/1125/2436/?random")!
        let downloadPicTask = session.dataTask(with: imageURL) { (data, response, error) in
            if let e = error {
                print(e)
                DispatchQueue.main.async {
                    self.mainImageView.image = UIImage(named: "defaultBackground")
                }
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async{
                        UIView.transition(with: self.mainImageView,
                                          duration:0.5,
                                          options: .transitionCrossDissolve,
                                          animations: { self.mainImageView.image = image },
                                          completion: nil)
                    }
                }
            }
        }
        downloadPicTask.resume()
    }
    
    let imagePicker = UIImagePickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            dismiss(animated: true, completion: nil)
            DispatchQueue.global(qos: .background).async {
                let imageData: Data = image.pngData()! as Data
                if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                    userDefaults.set(imageData, forKey: "schedule1")
                    userDefaults.synchronize()
                }
            }
        }
    }
}

