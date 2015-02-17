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
  s.version          = "0.2.0"
  s.summary          = "IOToastInput is toast with textfield"
  s.description      = <<-DESC
                        IOToastInput give you nice toast with just 1 line of code
                     DESC
  s.homepage         = "https://github.com/ibeneb/IOToastInput"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Benjamin Prieur" => "benjamin@prieur.org" }
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
