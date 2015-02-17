# IOToastInput

[![CI Status](http://img.shields.io/travis/ibeneb/IOToastInput.svg?style=flat)](https://travis-ci.org/ibeneb/IOToastInput)
[![Version](https://img.shields.io/cocoapods/v/IOToastInput.svg?style=flat)](http://cocoadocs.org/docsets/IOToastInput)
[![License](https://img.shields.io/cocoapods/l/IOToastInput.svg?style=flat)](http://cocoadocs.org/docsets/IOToastInput)
[![Platform](https://img.shields.io/cocoapods/p/IOToastInput.svg?style=flat)](http://cocoadocs.org/docsets/IOToastInput)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Prerequisites

IOToastInput advantages of recent Objective-C runtime advances, including ARC and blocks. It requires:

- iOS 7 or later.

## Installation

IOToastInput is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "IOToastInput"

## Example of usage

````objc
[IOToastInputManager showNotificationWithMessage:@"You can insert your text" completionBlock:^ (NSInteger index, NSString *text) {

}];
````

## Author

Benjamin Prieur

## License

IOToastInput is available under the MIT license. See the LICENSE file for more info.

