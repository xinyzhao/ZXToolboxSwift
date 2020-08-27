# ZXToolboxSwift
My development kit for iOS

## Requirements

* Requires iOS 8.0 or later
* Requires Automatic Reference Counting (ARC)

## Installation with CocoaPods

Install [CocoaPods](http://cocoapods.org/) with the following command:

```
$ gem install cocoapods
```

Create a [Podfile](http://guides.cocoapods.org/using/the-podfile.html) into your project folder:

```
$ touch Podfile
```

Add the following line to your `Podfile`:

```
platform :ios, '8.0'

target 'TargetName' do
pod "ZXToolboxSwift"
end
```

Then, run the following command:

```
$ pod install
```

or

```
$ pod update
```

## Installation with Carthage

Install [Carthage](https://github.com/Carthage/Carthage) with Homebrew using the following command:

```
$ brew update
$ brew install carthage
```

Create a [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile) into your project folder:

```
$ touch Cartfile
```

Add the following line to your `Cartfile`:

```
github "xinyzhao/ZXToolboxSwift"
```

Then, run carthage to build the framework

```
$ carthage update --platform iOS
```

Drag the built ZXToolboxSwift.framework into your Xcode project.

## Usage

```
import ZXToolboxSwift
```

## Foundation

* KVObserver
* DispatchQueue+AsyncAfterEvent

## UIKit

* CAGradientLayer+Direction
* DashLineView
* TitleBarController
* UIView+Animation
* UIViewController+Alert

## License

`ZXToolboxSwift` is available under the MIT license. See the `LICENSE` file for more info.
