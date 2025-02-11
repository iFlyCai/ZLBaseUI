#
# Be sure to run `pod lib lint ZLBaseUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZLBaseUI'
  s.version          = '1.2.6'
  s.summary          = 'A short description of ZLBaseUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'ZLBaseUI'

  s.homepage         = 'https://github.com/iFlyCai/ZLBaseUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ExistOrLive' => '2068531506@qq.com' }
  s.source           = { :git => 'https://github.com/iFlyCai/ZLBaseUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.6'

  s.source_files = 'ZLBaseUI/Classes/**/*'
  
   s.resource_bundles = {
     'ZLBaseUI' => ['ZLBaseUI/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # 依赖库
  s.dependency 'RTRootNavigationController', '~> 0.8.1'
end
