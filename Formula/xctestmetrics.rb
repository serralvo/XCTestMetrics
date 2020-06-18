class Xctestmetrics < Formula
  desc "Command-line tool that provides metrics about your project tests"
  homepage "https://github.com/serralvo/XCTestMetrics"
  url "https://github.com/serralvo/XCTestMetrics.git", :tag => "0.0.7"
  version "0.0.8"
  
  depends_on :xcode => ["11.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

end
