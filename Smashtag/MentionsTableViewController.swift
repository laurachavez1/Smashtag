//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Laura Chavez.
//  Copyright © 2016 Laura Chavez. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                mentions.append(Mentions(title: "Images",
                    data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls {
                mentions.append(Mentions(title: "URLs",
                    data: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags {
                mentions.append(Mentions(title: "Hashtags",
                    data: hashtags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions {
                mentions.append(Mentions(title: "Users",
                    data: users.map { MentionItem.Keyword($0.keyword) }))
            }
        }
    }
    
    var mentions: [Mentions] = []
    
    struct Mentions: CustomStringConvertible
    {
        var title: String
        var data: [MentionItem]
        
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: CustomStringConvertible
    {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    // MARK: - UITableViewControllerDataSource
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keyword Cell"
        static let ImageCellReuseIdentifier = "Image Cell"
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Storyboard.KeywordCellReuseIdentifier,
                forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                Storyboard.ImageCellReuseIdentifier,
                forIndexPath: indexPath) as! MentionsTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }

}
