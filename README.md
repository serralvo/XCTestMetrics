<p align="center">
  <img src="logo.png" width="315" max-width="50%" alt=“XCTestMetrics Logo”/>
</p>
<p align="center">
    <a href="https://swift.org">
      <img src="https://img.shields.io/badge/swift-5.2-orange.svg" />
    </a>
    <a href="https://github.com/serralvo/XCTestMetrics/workflows/Swift/badge.svg?branch=master">
      <img src="https://github.com/serralvo/XCTestMetrics/workflows/Swift/badge.svg?branch=master"/>
    </a>
    <a href="https://github.com/serralvo/XCTestMetrics/blob/master/LICENSE">
      <img src="https://img.shields.io/badge/License-MIT-blue.svg"/>
    </a>
    <a href="https://twitter.com/serralvo_">
      <img src="https://img.shields.io/badge/contact-@serralvo_-blue.svg?style=flat"/>
    </a>
</p>

<p align="center">Welcome to <strong>XCTestMetrics<strong>, a command-line tool that provides metrics about your project tests.</p>

![XCTestMetrics Report on Slack](https://github.com/serralvo/Tractor/blob/master/report-image.png)

# Features
- [x] Get metrics about your project tests, like the number of failures, when it happened, the percentage of flakiness.
- [x] Identify flaky tests.
- [x] Easy and fast setup.

# Requirements
- Xcode 11 

# Installation 

## Homebrew
```
$ brew tap serralvo/XCTestMetrics https://github.com/serralvo/XCTestMetrics.git
$ brew install serralvo/XCTestMetrics/xctestmetrics
```
## CocoaPods
```
pod 'XCTestMetrics'
```

# Usage
The usage of XCTestMetrics is based on two steps: the first one is to register each test result, the second one is to display all results using a report.

## First Step:
- Run project tests.
- Get the path of your project inside `DerivedData` folder. 
  - Will be something like this: `~/Library/Developer/Xcode/DerivedData/YourProject-gybqxixuerfernzjaklbxkwwstqj`
- Call `log` command using derived data path:

```
$ xctestmetrics log path-to-derived-data
```
- The log will be added to `xctestmetrics-output` folder.
- Commit the log file.
```
$ git add xctestmetrics-output/.
$ git commit -m "Adds xctestmetrics log" 
```

⚠️ Important, do it for every build of your project, use this tool on your continuous integration system.

## Second Step:

### Slack
- You will need to input a webhook URL:
  - Will be something like this: `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`
  - [Check here how to create a webhook.](https://api.slack.com/messaging/webhooks)
- Run: 
```
$ xctestmetrics report slack your-web-hook-url
```
- That's it! The message with metrics will be sent to Slack.

### HTML
- Run:
```
$ xctestmetrics report html
```
- That's it! The report file (index.html) will be stored into `xctestmetrics-report` folder.

If you want remove  `xctestmetrics-output` after report generation:

```
$ git rm -r xctestmetrics-output/
$ git add . 
$ git commit -m "Removes xctestmetrics-output folder"
```

# License
XCTestMetrics is released under the [MIT License](https://opensource.org/licenses/MIT).

# Credits
Made with ❤️ by [Fabrício Serralvo](https://twitter.com/serralvo_)
