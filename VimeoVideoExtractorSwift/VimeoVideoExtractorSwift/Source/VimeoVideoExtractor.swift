//
//  VimeoVideoExtractor.swift
//  VimeoVideoExtractorSwift
//
//  Created by Usman Nisar on 6/8/18.
//  Copyright © 2018 Usman Nisar. All rights reserved.
//

import UIKit
import AVFoundation

//for vimeo video thumbnail extraction
enum VimeoThumbnailQuality : Int
{
    case eVimeoThumbUnknown = 0, eVimeoThumb640, eVimeoThumb960, eVimeoThumb1280, eVimeoThumbBase
    
    var description : String
    {
        switch self
        {
        // Use Internationalization, as appropriate.
        case .eVimeoThumbUnknown: return "unknown"
        case .eVimeoThumb640: return "640"
        case .eVimeoThumb960: return "960"
        case .eVimeoThumb1280: return "1280"
        case .eVimeoThumbBase: return "base"
        }
    }
}

//for vimeo video thumbnail extraction
enum VimeoVideoQuality : Int
{
    case eVimeoVideoUnknown = 0, eVimeoVideo360, eVimeoVideo540, eVimeoVideo640, eVimeoVideo720, eVimeoVideo960, eVimeoVideo1080
    
    var description : String
    {
        switch self
        {
        // Use Internationalization, as appropriate.
        case .eVimeoVideoUnknown: return "unknown"
        case .eVimeoVideo360: return "360p"
        case .eVimeoVideo540: return "540p"
        case .eVimeoVideo640: return "640p"
        case .eVimeoVideo720: return "720p"
        case .eVimeoVideo960: return "960p"
        case .eVimeoVideo1080: return "1080p"
        }
    }
}

class VimeoVideoExtractor: NSObject
{
    var pVideoTitle = ""
    var thumbnailURL = ""
    var videoURL = ""
    
    static func extractVideoFromVideoID(videoID:String, thumbQuality:VimeoThumbnailQuality, videoQuality:VimeoVideoQuality, completionHandler: ((Bool, VimeoVideoExtractor?) -> Void)?)
    {
        let requestString = "https://player.vimeo.com/video/\(videoID)/config"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: URL(string: requestString)!) { (data, response, error) in
            //
            if error == nil
            {
                if data != nil
                {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! [String : Any]
                        
                        let videoObj = VimeoVideoExtractor()
                        videoObj.parseVideoResponse(videoDictionary: jsonObject, thumbQuality: .eVimeoThumb640, videoQuality: .eVimeoVideo540)
                        
                        completionHandler!(true, videoObj)
                        
                    } catch {
                        completionHandler!(false, nil)
                        print(error.localizedDescription)
                    }
                }
                else
                {
                    completionHandler!(false, nil)
                }
            }
            
        }.resume()
    }
    
    func parseVideoResponse (videoDictionary:[String:Any], thumbQuality:VimeoThumbnailQuality, videoQuality:VimeoVideoQuality)
    {
        if let videoData = videoDictionary["video"] as? NSDictionary
        {
            //extract video title from video data
            if let title = videoData.value(forKey: "title") as? String
            {
                self.pVideoTitle = title
            }
            
            //extract thumbnail from video data
            if let thumbData = videoData.value(forKey: "thumbs") as? NSDictionary
            {
                if let imageStr = thumbData.value(forKey: thumbQuality.description) as? String
                {
                    self.thumbnailURL = imageStr
                }
                //if desired quality does not exists..
                //search for avialable quality
                else if let imageStr = thumbData.value(forKey: VimeoThumbnailQuality.eVimeoThumb640.description) as? String
                {
                    self.thumbnailURL = imageStr
                }
                else if let imageStr = thumbData.value(forKey: VimeoThumbnailQuality.eVimeoThumb960.description) as? String
                {
                    self.thumbnailURL = imageStr
                }
                else if let imageStr = thumbData.value(forKey: VimeoThumbnailQuality.eVimeoThumbBase.description) as? String
                {
                    self.thumbnailURL = imageStr
                }
            }
            
            //now extract video playable url from data
            //its data object hierechi is: request -> files -> progressive
            if let requestData = videoDictionary["request"] as? NSDictionary
            {
                if let filesData = requestData.value(forKey: "files") as? NSDictionary
                {
                    if let progressiveDataArray = filesData.value(forKey: "progressive") as? NSArray
                    {
                        for object in progressiveDataArray
                        {
                            if let progressiveData = object as? NSDictionary
                            {
                                if let quality = progressiveData.value(forKey: "quality") as? String
                                {
                                    if quality == videoQuality.description
                                    {
                                        self.videoURL =  progressiveData.value(forKey: "url") as! String
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
