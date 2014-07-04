//
//  ViewController.swift
//  KeyboardExample
//
//  Created by Maciek on 04.07.2014.
//  Copyright (c) 2014 Maciej Scisłowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var scrollView: UIScrollView = UIScrollView()
    let textField: UITextField = UITextField()
    
    func handleKeyboardWillShow(paramNotification: NSNotification) {
        let userInfo: NSDictionary = paramNotification.userInfo
        /* Get the duration of the animation of the keyboard for when it
        gets displayed on the screen. We will animate our contents using
        the same animation duration */
        let animationDurationObject: NSValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSValue
        let keyboardEndRectObject: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        
        var animationDuration: Double = 0.0
        var keyboardEndRect: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0)
        animationDurationObject.getValue(&animationDuration)
        keyboardEndRectObject.getValue(&keyboardEndRect)
        
        let window: UIWindow = UIApplication.sharedApplication().keyWindow
        
        /* Convert the frame from window's coordinate system to
        our view's coordinate system */
        keyboardEndRect = self.view.convertRect(keyboardEndRect, fromView: window)
        
        /* Find out how much of our view is being covered by the keyboard */
        let intersectionOfKeyboardRectAndWindowRect: CGRect = CGRectIntersection(self.view.frame, keyboardEndRect)
        
        /* Scroll the scroll view up to show the full contents of our view */
        UIView.animateWithDuration(animationDuration, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, intersectionOfKeyboardRectAndWindowRect.size.height, 0.0)
            self.scrollView.scrollRectToVisible(self.textField.frame, animated: false)})
    }
    
    func handleKeyboardWillHide(paramSender: NSNotification) {
        let userInfo: NSDictionary = paramSender.userInfo
        let animationDurationObject: NSValue = userInfo.valueForKeyPath(UIKeyboardAnimationDurationUserInfoKey) as NSValue
        var animationDuration: Double = 0.0
        animationDurationObject.getValue(&animationDuration)
        UIView.animateWithDuration(animationDuration, animations: {
            self.scrollView.contentInset = UIEdgeInsetsZero})
    }
    
    override func viewWillAppear(animated: Bool)  {
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "handleKeyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "handleKeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(paramTextField: UITextField) -> Bool {
        paramTextField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(animated: Bool)  {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func controls() {
        let placeholder = "Type your name"
        textField.placeholder = placeholder
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.textAlignment = NSTextAlignment.Center;
        textField.borderStyle = UITextBorderStyle.Line
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.Done
        
        let scrollViewRect: CGRect = self.view.bounds
        scrollView = UIScrollView(frame: scrollViewRect)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(textField)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func constraints() {
        let metrics = [
            "topMargin":400,
            "leftMargin": 0,
            "width": self.view.bounds.width
        ]
        let leftConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-leftMargin-[textField(width)]-(>=0)-|", options: nil, metrics: metrics, views: ["textField": textField])
        
        let topConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topMargin-[textField]-(>=0)-|", options: nil, metrics: metrics, views: ["textField": textField])
        
        self.view.addConstraints(leftConstraints)
        self.view.addConstraints(topConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controls()
        constraints()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

