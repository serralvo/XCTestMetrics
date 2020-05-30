# XCTestMetrics
Welcome to **XCTestMetrics**, a command line tool that provides metrics about your project tests, focusing on the flaky.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

![XCTestMetrics Report on Slack](https://github.com/serralvo/Tractor/blob/master/report-image.png)

## Features
- [x] Help to identify flaky tests.
- [x] Give the big picture of project tests, number of failures, when it happened, percentage of flakiness.
- [x] Easy and fast setup.

## Requirements
- Xcode 11 

## Installation
Using [Homebrew](http://brew.sh/):

## Usage
The usage of XCTestMetrics is based on two steps: the first one is register each build result, the second one is display all results using a report.

### First Step:
- Run project tests.
- Get the path of your project inside `DerivedData` folder. 
  - Will be something like this: `~/Library/Developer/Xcode/DerivedData/YourProject-gybqxixuerfernzjaklbxkwwstqj`
- Call `log` command using derived data path:

```
$ xc-test-metrics log path-to-derived-data
```
- The log will be added to `xctestmetrics-output` folder.
- Commit the log file.
```
$ git add xctestmetrics-output/.
$ git commit -m "Adds xctestmetrics log" 
```

⚠️ Important, do it for every build of your project, use this tool on your continuous integration system.

### Second Step:
First question, which report you want: Slack or HTML?

#### Slack
- You will need to input a webhook URL:
  - Will be somethink like this: `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`
  - [Check here how to create a webhook.](https://api.slack.com/messaging/webhooks)
- Run: 
```
$ xc-test-metrics report slack your-web-hook-url
```
- That's it! The message with metrics will be send to Slack.

#### HTML
- Run:
```
$ xc-test-metrics report html
```
- That's it! The report file (index.html) will be stored into `xctestmetrics-report` folder.

## Motivation
The first thing to do when your codebase has flaky tests is **get metrics about it**. With data you can pick the test that failed more times for example, to fix, re-write or even delete. 

## License
XCTestMetrics is released under the [MIT License](https://opensource.org/licenses/MIT).

## Credits
Made with ❤️ by [Fabrício Serralvo](https://twitter.com/serralvo_)

[swift-image]:https://img.shields.io/badge/swift-5.2-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
