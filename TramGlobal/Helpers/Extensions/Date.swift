//
//  TramGlobal
//
//  Created by Akhil on 02/12/23.
//

import Foundation

extension Date {
    
    func timeIntervalInString() -> String {
        let string = "\(self.timeIntervalSince1970)"
        let newString = string.replacingOccurrences(of: ".", with: "")
        return newString
    }
    
    func getTimeIntervalShort() -> String {
        let string = "\(self.timeIntervalSince1970)"
        let newString = string.components(separatedBy: ".").first ?? timeIntervalInString()
        return newString
    }
    
    func localDateString() -> String {
        return self.description(with: .current)
    }
    
    func localDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
    
    func getDateYYYYMMDD() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
    
    func getFullDateAndTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        return df.string(from: self)
    }
    
    func earlyDateForHours(hours: Int) -> Date? {
        guard let earlyDate = Calendar.current.date(
            byAdding: .hour,
            value: -hours,
            to: Date()) else {
            return nil
        }
        
        return earlyDate
    }
    
    func earlyDateForMinutes(minutes: Int) -> Date? {
        guard let earlyDate = Calendar.current.date(
            byAdding: .minute,
            value: -minutes,
            to: Date()) else {
            return nil
        }
        
        return earlyDate
    }
    
    func convertToUserFormate(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, showToday: Bool = false) -> String  {
        
        if showToday {
            let originalDate = self.removeTimeStamp
            let currentDate = Date().removeTimeStamp
            let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!.removeTimeStamp
            let tomorowDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!.removeTimeStamp
            if originalDate == currentDate {
                return "Today"
            } else if originalDate == tomorowDay {
                return "Tomorrow"
            } else if originalDate == yesterDay {
                return "Yesterday"
            } else {
                return ""
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            return formatter.string(from: self)
        }
    }
    //    static func dateFromServerFormat(from string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
    //        _serverFormatter.dateFormat = format
    //        return _serverFormatter.date(from: string)
    //    }
    //
    //    static func dateFromLocalFormat(from string: String, format: String = "MM-dd-yyyy") -> Date? {
    //        _deviceFormatter.dateFormat = format
    //        return _deviceFormatter.date(from: string)
    //    }
    //
    //    static func localDateString(from date: Date?, format: String = "MM-dd-yyyy") -> String {
    //        _deviceFormatter.dateFormat = format
    //        if let _ = date {
    //            return _deviceFormatter.string(from: date!)
    //        } else {
    //            return ""
    //        }
    //    }
    //
    //    static func serverDateString(from date: Date?, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String {
    //        _serverFormatter.dateFormat = format
    //        if let _ = date {
    //            return _serverFormatter.string(from: date!)
    //        } else {
    //            return ""
    //        }
    //    }
    
//        func removeTimeFromDate() -> Date {
//            let str = Date.localDateString(from: self, format: "MM-dd-yyyy")
//            return Date.dateFromLocalFormat(from: str, format: "MM-dd-yyyy")!
//        }
    
    
    public var removeTimeStamp : Date? {
           guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
           }
           return date
       }
    
    func getDateComponents() -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        return (year, month, day, hour, minute)
    }
    
    func getAge() -> Int {
        
        // If date has not set years
        if let years = self.getDateComponents().year, years <= 1  {
            return 0
        }
        
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        
        guard let age = ageComponents.year else {
            return 0
        }
        return age
    }
    
    func getTomorrowDate() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
    
    func addTimeToDate(min: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: min, to: self) ?? Date()
    }
    
    func addTimeToDate(hours: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: hours, to: self) ?? Date()
    }
    
    func getContestStartIn(toDate: Date? = nil) -> (hour: Int, min: Int) {
        let calendar = Calendar.current
        let components = Set<Calendar.Component>([.minute, .hour])
        let differenceOfComp = calendar.dateComponents(components, from: toDate ?? Date(), to: self)
        return (differenceOfComp.hour ?? 0, differenceOfComp.minute ?? 0)
    }
    
    func getContestStartInSecond(toDate: Date? = nil) -> (day: Int, hour: Int, min: Int, sec: Int) {
        let calendar = Calendar.current
        let components = Set<Calendar.Component>([.day, .hour, .minute, .second])
        let differenceOfComp = calendar.dateComponents(components, from: toDate ?? Date(), to: self)
        return (differenceOfComp.day ?? 0, differenceOfComp.hour ?? 0, differenceOfComp.minute ?? 0, differenceOfComp.second ?? 0)
    }
    
    //    func getContestDate() -> String {
    //        let orgDate = self.removeTimeFromDate()
    //        let curDate = Date().removeTimeFromDate()
    //        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!.removeTimeFromDate()
    //        let tomorowDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!.removeTimeFromDate()
    //        if orgDate == curDate{
    //            return "Today"
    //        } else if orgDate == tomorowDay {
    //            return "Tomorrow"
    //        } else if orgDate == yesterDay {
    //            return "Yesterday"
    //        } else{
    //            return Date.localDateString(from: self, format: "dd MMM yyyy")
    //        }
    //    }
    
    func getDateSufix() -> String {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: self)
        
        var day  = "st"
        if let value = anchorComponents.day {
            switch ("\(value)") {
            case "1" , "21" , "31":
                day = "st"
            case "2" , "22":
                day = "nd"
            case "3" ,"23":
                day = "rd"
            default:
                day = "th"
            }
        }
        
        return day
    }
    
    
    
    func agoStringFromTime()-> String {
        let timeScale = ["now"  :1,
                         "min"  :60,
                         "hr"   :3600,
                         "day"  :86400,
                         "week" :605800,
                         "mth"  :2629743,
                         "year" :31556926];
        
        var scale : String = ""
        var timeAgo = 0 - Int(self.timeIntervalSinceNow)
        if (timeAgo < 60) {
            scale = "now";
        } else if (timeAgo < 3600) {
            scale = "min";
        } else if (timeAgo < 86400) {
            scale = "hr";
        } else if (timeAgo < 605800) {
            scale = "day";
        } else if (timeAgo < 2629743) {
            scale = "week";
        } else if (timeAgo < 31556926) {
            scale = "mth";
        } else {
            scale = "year";
        }
        
        timeAgo = timeAgo / Int(timeScale[scale]!)
        if scale == "now"{
            return scale
        }else{
            return "\(timeAgo) \(scale) ago"
        }
    }
    
    static func -(recent: Date, previous: Date) -> (year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let year = Calendar.current.dateComponents([.year], from: previous, to: recent).year
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    func isSameDay() -> Bool {
        
        let calendar = Calendar.current

        // User date
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let year = components.year
        let month = components.month
        let day = components.day
        
        // Current date
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: Date())
//        let currentYear = currentComponents.year
        let currentDay = currentComponents.day
        let currentMonth = currentComponents.month
        
        if year == 1 {
            // When user has not set the year
            if (day == currentDay && month == currentMonth) {
               return true
            } else {
                return false
            }
        } else {
            if (day == currentDay && month == currentMonth) {
               return true
            } else {
                return false
            }
        }
    }
}
