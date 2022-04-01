//
//  News.swift
//  ReignTest
//
//  Created by Pedro Valderrama on 30/03/2022.
//

import Foundation

struct News: Equatable, Codable {
    let title: String?
    let storyTitle: String?
    let author: String
    let createdAt: String
    let storyURL: String?
    let storyId: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case createdAt = "created_at"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case storyId = "story_id"
    }
    
    var titleComputed: String? {
        guard title?.isEmpty != nil else {
            return storyTitle
        }
        return title
    }
    
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // format iso8601
        // create a new date given the API date
        let date = dateFormatter.date(from: createdAt)!
        return "\(author) - \(date.timeAgo())"
    }
    
}

struct NewsResponse: Codable {
    let news: [News]
    
    enum CodingKeys: String, CodingKey {
        case news = "hits"
    }
    
}


extension Date {
    
    func timeAgo() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quantity: Int
        let unit: String
        
        if secondsAgo < hour {
            quantity = secondsAgo / minute
            unit = "m"
            return "\(quantity)\(unit)"
        } else if secondsAgo < day {
            quantity = secondsAgo / hour
            // De los minutos ej: 56, toma solo el primer numero: 5
            let minutes = ((((secondsAgo % 3600) / 60) / 10) % 10)
            unit = "h"
            return minutes == 0 ? "\(quantity)\(unit)" : "\(quantity).\(minutes)\(unit)"
        } else if secondsAgo < week {
            quantity = secondsAgo / day
            unit = "day"
            if quantity == 1 {
                return "Yesterday"
            }
        } else if secondsAgo < month {
            quantity = secondsAgo / week
            unit = "week"
        } else {
            quantity = secondsAgo / month
            unit = "month"
        }
        return "\(quantity) \(unit)\(quantity == 1 ? "" : "s") ago"
    }
    
}
