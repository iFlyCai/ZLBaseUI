Pod::Spec.new do |s|
  s.name             = 'ZLBaseUI'
  s.version          = '1.2.7'
  s.summary          = 'A short description of ZLBaseUI.'
  s.description      = <<-DESC
    ZLBaseUI 是一个基于 UIKit 的基础 UI 组件库，封装了常用的 UI 组件，提供更便捷的使用方式，提高开发效率。
  DESC

  s.homepage         = 'https://github.com/iFlyCai/ZLBaseUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ExistOrLive' => '2068531506@qq.com' }
  s.source           = { :git => 'https://github.com/iFlyCai/ZLBaseUI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.6'
  s.source_files = 'ZLBaseUI/Classes/**/*.{h,m}'
  
  s.public_header_files = 'ZLBaseUI/Classes/**/*.h'
  
  s.resource_bundles = {
    'ZLBaseUI' => ['ZLBaseUI/Assets/**/*']
  }

  s.frameworks = 'UIKit'
  
  s.dependency 'RTRootNavigationController', '~> 0.8.1'
end
