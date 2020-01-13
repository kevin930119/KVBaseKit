#
# Be sure to run `pod lib lint KVBaseKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KVBaseKit'
  s.version          = '0.1.4'
  s.summary          = '这是Kevin的开发基础库Swift版本'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Kevin的开发基础库Swift，需要很长很长的描述，哈哈哈哈"

  s.homepage         = 'https://github.com/kevin930119/KVBaseKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kevin' => '673729631@qq.com' }
  s.source           = { :git => 'https://github.com/kevin930119/KVBaseKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'
  
  s.frameworks = 'UIKit'
#  s.dependency 'SDWebImage'

  s.source_files = 'KVBaseKit/Classes/**/*'
  
  s.public_header_files = 'KVBaseKit/Classes/**/*.h'
  
  # s.resource_bundles = {
  #   'KVBaseKit' => ['KVBaseKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
