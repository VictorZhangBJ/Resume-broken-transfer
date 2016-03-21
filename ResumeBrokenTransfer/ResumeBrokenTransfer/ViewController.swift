//
//  ViewController.swift
//  ResumeBrokenTransfer
//
//  Created by 张佳宾 on 16/3/17.
//  Copyright © 2016年 victor. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NSURLSessionDownloadDelegate {

    let download_url = "http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"
    var downloadTask: NSURLSessionDownloadTask!
    var isDownloading = false
    
    var resumeData: NSData!
    var session: NSURLSession!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func btnClick(sender: AnyObject) {
        let button = sender as! UIButton
        if(button.titleLabel!.text == "下载"){
            
            if(isDownloading){
                //恢复下载
                downloadTask = session.downloadTaskWithResumeData(resumeData)
                downloadTask .resume()
                print("继续下载");
            }else{
                //从头开始下载
                download(download_url)
                isDownloading = true
            }
            
            button.setTitle("暂停", forState: .Normal)
        }else{
            downloadTask!.cancelByProducingResumeData({ (data: NSData?) -> Void in
                print("暂停下载")
                self.resumeData = data
            })
            
            button.setTitle("下载", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0.0;
        
    }
    func download(URLString: String){
        let url = NSURL(string: URLString)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        downloadTask = session .downloadTaskWithURL(url!)
        
        //创建任务
//        let downloadTask = session.downloadTaskWithURL(url!, completionHandler: { (location: NSURL?,response: NSURLResponse?,error: NSError?) -> Void in
//            let array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//            let caches = array.last
//            let file = caches?.stringByAppendingFormat("/%s", (response?.suggestedFilename)!)
//            print("file = \(file)")
//            
//            let fm = NSFileManager.defaultManager()
//            try! fm.moveItemAtPath((location?.path)!, toPath: file!)
//            
//            
//            
//        })
        
        downloadTask!.resume()
        
        
    }
    
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下载完毕")
        isDownloading = false
        
        print("文件保存位置\(location.path)")
        if let fileName = downloadTask.response?.suggestedFilename {
            //转移文件到缓存目录
            let cache = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
            let filePath = cache! + "/" + fileName;
            print("filePath = \(filePath)")
            let fm = NSFileManager.defaultManager()
            try! fm.moveItemAtPath(location.path!, toPath: filePath)
            
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = NSString(format: "下载进度: %.2f", (Float)(totalBytesWritten) / (Float)(totalBytesExpectedToWrite))
        progressLabel.text = progress as String
        progressView.progress = (Float)(totalBytesWritten) / (Float)(totalBytesExpectedToWrite)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

