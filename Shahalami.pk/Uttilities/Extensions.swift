//
//  ViewAdditions.swift
//  EZDeals
//
//  Created by Narsun on 30/03/2019.
//  Copyright © 2019 Narsun. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

extension NSObject {
    var classIdentifier: String {
        return String(describing: type(of: self))
    }
    
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}

extension UIFont {
    static func availableFonts() {
        // Get all fonts families
        for family in UIFont.familyNames {
            //            log("\(family)")
            // Show all fonts for any given family
            for name in UIFont.fontNames(forFamilyName: family) {
                //                log("   \(name)")
            }
        }
    }
}


extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension UIViewController {
    func appBarDesignInExtensions() {
        navigationController?.navigationBar.isTranslucent =  false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2877477407, green: 0.2236644924, blue: 0.1979552507, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 28)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let viewControllerName = String.init(describing: self.classForCoder)
        print("ViewController Name: \(viewControllerName)")
    }
}

extension Array {
    func copiedElements() -> Array<Element> {
        return self.map{
            let copiable = $0 as! NSCopying
            return copiable.copy() as! Element
        }
    }
    
    
}
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 133/255, blue: 185/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 4.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 17/255, green: 133/255, blue: 185/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
//class EZTextField: UITextField {
//
//    private func getKeyboardLanguage() -> String? {
//
//        let appDelegate : AppDelegate = AppDelegate.shared
////        if appDelegate.appLanguage == .english {
////            return "en"
////        }else{
////            return "ur"
////        }
//    }
//
//    override var textInputMode: UITextInputModre? {
//        if let language = getKeyboardLanguage() {
//            for tim in UITextInputMode.activeInputModes {
//                if tim.primaryLanguage!.contains(language) {
//                    return tim
//                }
//            }
//        }
//        return super.textInputMode
//    }
//
//}


@IBDesignable extension UILabel {
    
    func adjustAlignment() {
//        if let appLanguage = AppDelegate.shared.getSettings() as? AppLanguage {
//            self.textAlignment = (appLanguage == .english) ? NSTextAlignment.left : NSTextAlignment.right
//        }else{
//            self.textAlignment = NSTextAlignment.left
//        }
    }
    
}


@IBDesignable extension UIView {
    
    
    func addShadow(opacity: Float, cornerRadius: Float, shadowRadius:Float ,borderColor:CGColor ,borderWith:CGFloat) {
        
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowOffset = .zero
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor
        //self.clipsToBounds = true
        
    }
    func addShadow(opacity: Float, cornerRadius: Float, shadowRadius:Float) {
        
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowOffset = CGSize(width: 2.0,height: 2.0)
      //  self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
//        self.layer.borderWidth = borderWith
//        self.layer.borderColor = borderColor
        //self.clipsToBounds = true
        
    }
    func uiViewShadow() {
        
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 2.0,height: 2.0)

      }
    
    func buttonUiViewShadow() {
        
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = .zero

      }
    
    
    public var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
  
    
    public var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    
    public var centerX: CGFloat{
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue,y: self.centerY) }
    }
    public var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX,y: newValue) }
    }
    
    public var origin: CGPoint {
        set { self.frame.origin = newValue }
        get { return self.frame.origin }
    }
    
    //    public var size: CGSize {
    //        set { self.frame.size = newValue }
    //        get { return self.frame.size }
    //    }
    
    
}
extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
extension UIImageView {
    func applyShadow(){
      //  self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2.0,height: 2.0)
        self.layer.shadowRadius = 4
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.clipsToBounds = true
  
    }
}
protocol TopUIViewController {
    func topUIViewController() -> UIViewController?
}

extension Optional {
    func unwraped<T>(defaultV:T) -> T {
        switch self {
        case .some(let value):
            return value as? T ?? defaultV
        case _:
            return defaultV
        }
    }
}

extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height/2) - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            lblMessage.alpha = 1
        }, completion: {
            sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
            bgView.removeFromSuperview()
        })
    }
}
extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}



// MARK: UIDevice
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension String {
    
    var length: Int { return self.count }
    
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$";
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    
    func isValidEmail(regex: RegularExpressions) -> Bool {
        return isValidEmail(regex: regex.rawValue);
    }
    
    func isValidEmail(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression);
        return matches != nil;
    }
    
    func integerValue() -> Int {
        return Int(self).unwraped(defaultV: 0)
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        
        //        log(indexPosition)
        
        if self != "" {
            return self[indexPosition]
        }else{
            return nil
        }
        
        //        if endIndex <= indexPosition {
        //        }else{
        //            return "0"
        //        }
        
    }
    
}

extension StringProtocol {
    
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension LosslessStringConvertible {
    var string: String { return String(self) }
}


extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

extension NSNotification.Name {
    
    static let UpdateQuestionViews = NSNotification.Name("updateQuestionViews")
    static let UpdateSettings = NSNotification.Name("UpdateSettings")
    static let UpdateNotifications = NSNotification.Name("UpdateNotifications")
    static let UPDATE_NUMERIC_QUESTION_BUTTON = NSNotification.Name("UPDATE_NUMERIC_QUESTION_BUTTON")
    static let POPUP_DISMISSED = NSNotification.Name("POPUP_DISMISSED")
    static let networkisreachable = Notification.Name("networkisreachable")
    static let networknotreachable = Notification.Name("networknotreachable")
    static let lownetworkreachable = Notification.Name("lownetworkreachable")
    static let highnetworkreachable = Notification.Name("highnetworkreachable")
    
    static let SOCKETUpdateQuestionNotification = NSNotification.Name("SOCKETUpdateQuestionNotification")
    static let SOCKETUpdateSlotNotification = NSNotification.Name("SOCKETUpdateSlotNotification")
    static let SOCKETUpdateAnswerNotification = NSNotification.Name("SOCKETUpdateAnswerNotification")
    static let SOCKETUpdateOfflineSlotDataNotification = NSNotification.Name("SOCKETUpdateOfflineSlotDataNotification")
    static let SOCKETUpdateStatsNotification = NSNotification.Name("SOCKETUpdateStatsNotification")
    
}

extension UISearchBar {

    // Due to searchTextField property who available iOS 13 only, extend this property for iOS 13 previous version compatibility
    var compatibleSearchTextField: UITextField {
        guard #available(iOS 13.0, *) else { return legacySearchField }
        return self.searchTextField
    }

    private var legacySearchField: UITextField {
        if let textField = self.subviews.first?.subviews.last as? UITextField {
            // Xcode 11 previous environment
            return textField
        } else if let textField = self.value(forKey: "searchField") as? UITextField {
            // Xcode 11 run in iOS 13 previous devices
            return textField
        } else {
            // exception condition or error handler in here
            return UITextField()
        }
    }
}

extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
}

extension Optional {
    
    func unwrapped<T>(defaultV:T) -> T {
        switch self {
        case .some(let value):
            return value as! T
        case _:
            return defaultV
        }
    }
    
    
    
}


extension UIView {
   
   func dropShadow(scale: Bool = true) {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.7
   }
   
   func addBottomRoundedEdge() {
      let offset: CGFloat = (self.frame.width * 0.5)
      let bounds: CGRect = self.bounds
      
      let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width , height: bounds.size.height / 2)
      let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
      let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset , height: bounds.size.height)
      let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
      rectPath.append(ovalPath)
      
      let maskLayer: CAShapeLayer = CAShapeLayer()
      maskLayer.frame = bounds
      maskLayer.path = rectPath.cgPath
      
      self.layer.mask = maskLayer
   }
   
}


extension UIColor {
    static var cancelButton = UIColor.init(red: 17/255, green: 115/255, blue: 188/255, alpha: 1)
}
extension UITextField {
   
   //MARK:- Set Image on the right of text fields
   
   func setupRightImage(imageName:String){
      let imageView = UIImageView(frame: CGRect(x: 5, y:5, width: 10, height: 7))
      imageView.image = UIImage(named: imageName)
      imageView.backgroundColor = UIColor.gray
      let imageContainerView: UIView = UIView(frame: CGRect(x: -35, y: 0, width: 20, height: 20))
      imageContainerView.addSubview(imageView)
      imageContainerView.backgroundColor = UIColor.black
      rightView = imageContainerView
      rightViewMode = .always
      self.tintColor = .lightGray
   }
    
    
   
   //MARK:- Set Image on left of text fields
   
   func setupLeftImage(imageName:String){
      let imageView = UIImageView(frame: CGRect(x: 5, y: 6, width: 10, height: 7))
      imageView.image = UIImage(named: imageName)
   // imageView.backgroundColor = UIColor.gray
      let imageContainerView: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
      imageContainerView.addSubview(imageView)
    //imageContainerView.backgroundColor = UIColor.black
      leftView = imageContainerView
      leftViewMode = .always
      self.tintColor = .lightGray
   }
    
    //MARK:- Set bottom border only of text field
     func bottomBorder(textfeild:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfeild.frame.height - 1, width: textfeild.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfeild.borderStyle = UITextField.BorderStyle.none
        textfeild.layer.addSublayer(bottomLine)
    }
    
    
    
   
}
extension UIView {
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}

extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
}


    
    
    extension UIColor {
        
        static func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
    
  
extension UITextField {

enum Direction {
    case Left
    case Right
}
    
    

// add image to textfield
func withImage(direction: Direction, image: UIImage){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 7, width: 20, height: 20))
    view.backgroundColor = .white
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
    view.addSubview(imageView)

    if(Direction.Left == direction){ // image left
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        self.rightViewMode = .always
        self.rightView = mainView
    }

}
    
    // add image to textfield
    func textFieldwithImage(direction: Direction, image: UIImage, iconBtn: UIButton){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
       // view.layer.borderWidth = CGFloat(0)
       // view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        
        let iconButton = iconBtn
        iconButton.titleLabel?.text = ""
        iconButton.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(iconButton)
        
//        let seperatorView = UIView()
//        seperatorView.backgroundColor = colorSeparator
//        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
           // seperatorView.frame = CGRect(x: 45, y: 0, width: 2, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
          //  seperatorView.frame = CGRect(x: 0, y: 0, width: 2, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
      //  self.layer.borderColor = colorBorder.cgColor
       // self.layer.borderWidth = CGFloat(2.0)
        //self.layer.cornerRadius = 10
    }
    
    
    
    // add image to textfield
    func addEmptyView(direction: Direction){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 7, width: 9, height: 9))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        mainView.addSubview(view)

        if(Direction.Left == direction){ // image left
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            self.rightViewMode = .always
            self.rightView = mainView
        }

    }
    

}


