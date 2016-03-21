# Resume-broken-transfer
iOS开发当中，下载文件还是比较普遍的操作，对于一般的图片或者内容直接用`NSData dataWithContentsOfURL` 即可实现。但是这个方法有个问题，它会把下载下来的data存到内存当中去，如果是超过几个G的大文件，内存会爆的，所以对于大文件来说，我们必须选择另外一种方式。
iOS7 以后Apple推出了NSURLSession ，比原来的N S U onnection更加强大、灵活，最新的AFNetworking3.0 也是基于此来实现的。我们就用NSURLSession来实现大文件下载以及断点续传。

既然不能放内存里，那必须在本地创建一个文件让每次下载的文件流data拼接到这个文件上去，Apple默认的目录位置是放在tmp/文件夹里，但是下次启动的时候，这个目录会被清理，所以下载完成后，我们要把文件转移到另外一个目录当中去。

首先创建NSURLSession，初始化dataTask 然后 resume 
```
`
  let url = NSURL(string: URLString)
  let config = NSURLSessionConfiguration.defaultSessionConfiguration()
  session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
  downloadTask = session .downloadTaskWithURL(url!)
  downloadTask!.resume()
`
