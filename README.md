# VimeoVideoExtractorSwift
swift 4.0 supported version of VimeoVideoExtractor

VimeoVideoExtractor is an easy way to extract the Vimeo video details like title, thumbnail and playable mp4 URL which then can be used to play using AVPlayer

Integration:

Simply import source folder into your project and use bellow method to extract vimeo video details

static func extractVideoFromVideoID(videoID:String, thumbQuality:VimeoThumbnailQuality, videoQuality:VimeoVideoQuality, completionHandler: ((Bool, VimeoVideoExtractor?) -> Void)?)

I used object class VimeoVideoExtractor to store extracted data to properly elaborate extracted video information

thumbQuality: and videoQuality can be changed as per requirement.

see enums defined in VimeoVideoExtractor.h file for all possible video or thumbnail qualities.

Happy coding....
