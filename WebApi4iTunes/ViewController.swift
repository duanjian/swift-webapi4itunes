//
//  ViewController.swift
//  WebApi4iTunes
//
//  Created by duan jian on 15/3/13.
//  Copyright (c) 2015年 duan jian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var appsTable: UITableView!

    
    var tableData: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchApps("Tv")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Subtitle,reuseIdentifier:"cell")
        
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.textLabel!.text = rowData["trackName"] as? String
        
        var urlString: NSString = rowData["artworkUrl60"] as NSString
        var imgURL: NSURL = NSURL(string:urlString)!
        
        var imgData: NSData = NSData(contentsOfURL: imgURL)!
        cell.imageView?.image = UIImage(data: imgData)
        
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        cell.detailTextLabel?.text = formattedPrice
        
//        cell.textLabel?.text = "Main"
//        cell.detailTextLabel?.text = "detail Text"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    //搜索
    func searchApps(searchTerm:String){
        //使用空字符串替换+，对比时模式为大小写不敏感
        var appSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        //对中文和一些特殊字符进行编码
        var escapedSearchTerm = appSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        //地址
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm!)&media=software"
        var url: NSURL = NSURL(string: urlPath)!
        //声明会话，并发出静态请求
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if error != nil {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            
            println("my data is \(jsonResult)")
            
            if err != nil {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            var results: NSArray = jsonResult["results"] as NSArray
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.appsTable.reloadData()
            })
        })
        task.resume()
    }

}

