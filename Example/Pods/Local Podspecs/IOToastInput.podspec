#
# Be sure to run `pod lib lint IOToastInput.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IOToastInput"
  s.version          = "0.1.0"
  s.summary          = "IOToastInput is toast with textfield"
  s.description      = "IOToastInput show a toast with textfield with just 1 line of code and it's easy to personalize"
  s.homepage         = "https://github.com/ibeneb/IOToastInput"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Benjamin Prieur" => "benjamin@smok.io" }
  s.source           = { :git => "https://github.com/ibeneb/IOToastInput.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/bnj_p'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'IOToastInput' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'QuartzCore'
end
