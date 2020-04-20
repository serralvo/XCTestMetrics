# Tractor 🚜
Welcome to **Tractor**, a command line tool that provides metrics about your project tests, focusing on the flaky.

![Tractor Report on Slack](https://github.com/serralvo/Tractor/blob/master/tractor-report.png)

## Features
- [x] 🕵️‍♂️ Help to identify flaky tests.
- [x] 📊 Give the big picture of project tests, number of failures, when it happened, percentage of flakiness.
- [x] ⚡️ Easy and fast setup.

## Requirements 
- Xcode 11 

## Installation 
Using [Homebrew](http://brew.sh/):

## Usage
The usage of Tractor is based on two steps: the first one is register each build result, the second one is export all results using a report.

### First Step:
- Run project tests.
- Get the path of your project inside `DerivedData` folder. 
  - Will be something like this: ~/Library/Developer/Xcode/DerivedData/YourProject-gybqxixuerfernzjaklbxkwwstqj
- Finally, call `log` command using derived data path:

```
tractor log path-to-derived-data
```

⚠️ Important, do it for every build of your project, use this tool on your CI.

### Second Step:

## Motivation
The first thing to do when your codebase has flaky tests is **get metrics about it**. With data you can pick the test that failed more times for example, to fix, re-write or even delete. 

## License 
Tractor is released under the [MIT License](https://opensource.org/licenses/MIT).

## Credits
Made with ❤️ by [Fabrício Serralvo](https://twitter.com/serralvo_)
