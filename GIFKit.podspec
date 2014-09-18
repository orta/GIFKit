#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GIFKit"
  s.version          = "1.0.0"
  s.summary          = "The source for finding GIFs."
  s.description      = <<-DESC
                        Built out of a never-released in two years GIF app. The searching framework for finding GIFs on Reddit, Tumblr and Giphy.
                       DESC

  s.homepage         = "https://github.com/orta/GIFKit"
  s.license          = 'MIT'
  s.author           = { "Orta Therox" => "orta.therox@gmail.com" }
  s.source           = { :git => "https://github.com/orta/GIFKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/orta'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'

  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.dependency 'AFNetworking', '~> 2.3'
end
