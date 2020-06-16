# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
class Xctestmetrics < Formula
  desc "Command-line tool that provides metrics about your project tests"
  homepage "https://github.com/serralvo/XCTestMetrics"
  url "https://github.com/serralvo/XCTestMetrics.git", :tag => "0.0.6"
  version "0.0.6"
  
  depends_on :xcode => ["11.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

end