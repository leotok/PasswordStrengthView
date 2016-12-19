//
//  PasswordStrengthBar.swift
//  Leonardo Edelman Wajnsztok
//
//  Created by Leonardo Edelman Wajnsztok on 14/10/16.
//  Copyright © 2016 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

struct Rule {
    
    var text: String!
    var used = false
    var regex: String!
    
    init(text: String, regex: String) {
        self.text = text
        self.regex = regex
        self.used = false
    }
}

class PasswordStrengthView: UIView {
    
    public var enableHints = true {
        didSet {
            for h in hints {
                h.isHidden = !enableHints
            }
        }
    }
    
    public var enableBar = true {
        didSet {
            strengthBar.isHidden = !enableBar
        }
    }
    
    private var strength = 0 {
        didSet{
            updateBar()
        }
    }
    
    private var strengthBar: UIView!
    private var hints = [UILabel]()
    private var rules: [Rule] = [
        Rule(text: "Must contain as least 1 letter", regex: "[a-zA-Z]"),
        Rule(text: "Must contain as least 1 number", regex: "[0-9]"),
        Rule(text: "Must contain as least 6 characters", regex: ".{6,15}"),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        strengthBar = UIView(frame: CGRect(x:0, y:0, width: 0, height:frame.height * 0.1))
        strengthBar.layer.cornerRadius = 2
        strengthBar.clipsToBounds = true
        strengthBar.backgroundColor = UIColor.green
        addSubview(strengthBar)
        
        var i: CGFloat = 0
        
        for rule in rules {
            
            let hint = UILabel()
            hint.frame.size = CGSize(width:frame.width , height:50)
            hint.font = UIFont(name: "Avenir-Light", size: 16)
            hint.numberOfLines = -1
            hint.textAlignment = .left
            hint.center = CGPoint(x: frame.size.width / 2, y: 30 + (i * 40))
            
            let attrString = NSMutableAttributedString(string: rule.text)
            
            hint.attributedText = attrString
            addSubview(hint)
            hints.append(hint)
            i += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRule(text: String, regex: String) {
        let rule = Rule(text: text, regex: regex)
        rules.append(rule)
        
        let hint = UILabel()
        hint.frame.size = CGSize(width:frame.width , height:50)
        hint.font = UIFont(name: "Avenir-Light", size: 16)
        hint.numberOfLines = -1
        hint.textAlignment = .left
        hint.center = CGPoint(x: frame.size.width / 2, y: 30 + (CGFloat(hints.count) * 40))
        if enableHints == false {
            hint.isHidden = true
        }
        
        let attrString = NSMutableAttributedString(string: rule.text)
        
        hint.attributedText = attrString
        addSubview(hint)
        hints.append(hint)
    }
    
    func updateStrength(password: String) -> Bool {
        
        var power = 0
        
        for (index, rule) in rules.enumerated() {
            let match = matchesForRegexInText(regex: rule.regex, text: password).count
            if match > 0 {
                power += 1
                rules[index].used = true
                
                let attrString = NSMutableAttributedString(string: rules[index].text)
                attrString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, rules[index].text.characters.count))
                hints[index].attributedText = attrString
            }
            else {
                rules[index].used = false
                let attrString = NSMutableAttributedString(string: rules[index].text)
                hints[index].attributedText = attrString
            }
            
        }
        
        self.strength = power
        
        if power == rules.count {
            return true
        }
        else {
            return false
        }
    }
    
    func matchesForRegexInText(regex: String, text: String) -> [String] {
        //http://stackoverflow.com/questions/27880650/swift-extract-regex-matches
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    private func updateBar() {
        let percernt = (CGFloat(self.strength) / CGFloat(rules.count))
        
        strengthBar.frame.size.width = percernt * self.frame.width
        
        if percernt <= 0.26 {
            strengthBar.backgroundColor = UIColor.red
        }
        else if percernt <= 0.51 {
            strengthBar.backgroundColor = UIColor.yellow
        }
        else if percernt <= 0.76 {
            strengthBar.backgroundColor = UIColor.orange
        }
        else {
            strengthBar.backgroundColor = UIColor.green
        }
    }
}


