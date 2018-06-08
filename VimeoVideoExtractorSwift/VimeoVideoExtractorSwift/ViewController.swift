//
//  ViewController.swift
//  VimeoVideoExtractorSwift
//
//  Created by Usman Nisar on 6/8/18.
//  Copyright © 2018 Usman Nisar. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

class ViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var videoTitleLbl: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var videoPlayableURL : URL? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.urlTextField.text = "https://vimeo.com/channels/staffpicks/272806748"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //
        if self.urlTextField.isFirstResponder
        {
            self.urlTextField.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func extractButtonClicked(_ sender: Any)
    {
        let videoID = (self.urlTextField.text! as NSString).lastPathComponent
        
        VimeoVideoExtractor.extractVideoFromVideoID(videoID: videoID, thumbQuality: .eVimeoThumb640, videoQuality: .eVimeoVideo540) { (success, videoObj) in
            //
            if success
            {
                if videoObj != nil
                {
                    DispatchQueue.main.async {
                        //
                        self.videoTitleLbl.text = videoObj!.pVideoTitle
                        
                        if let url = URL(string: videoObj!.thumbnailURL)
                        {
                            self.thumbnailImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options:.cacheMemoryOnly, completed: { (image, error, cashe, url) in
                                //
                            })
                        }
                        
                        if let url = URL(string: videoObj!.videoURL)
                        {
                            self.videoPlayableURL = url
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func playButtonClicked(_ sender: Any)
    {
        if videoPlayableURL != nil
        {
            // create an AVPlayer
            let player = AVPlayer(url: videoPlayableURL!)
            
            // create a player view controller
            let controller = AVPlayerViewController()
            controller.player = player
            player.play()
            
            self.present(controller, animated: true, completion: nil)
        }
    }
}

