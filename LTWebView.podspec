#
# Be sure to run `pod lib lint LTWebView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LTWebView'
  s.version          = '0.1.0'
  s.summary          = '个人web工具.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
个人web工具 更新ing
                       DESC

  s.homepage         = 'https://github.com/yelon21/LTWebView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yelon21' => '254956982@qq.com' }
  s.source           = { :git => 'https://github.com/yelon21/LTWebView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '6.0'

  s.source_files = 'LTWebView/Classes/**/*'
  
  s.resource_bundles = {
    'LTWebView' => ['LTWebView/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
