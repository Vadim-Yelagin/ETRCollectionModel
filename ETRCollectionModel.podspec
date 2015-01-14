#
# Be sure to run `pod lib lint ETRCollectionModel.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ETRCollectionModel"
  s.version          = "0.1.0"
  s.summary          = "MVVM for iOS tables and collections."
  s.description      = <<-DESC
                       ETRCollectionModel
                       MVVM for iOS tables and collections.
                       DESC
  s.homepage         = "https://gitlab.eastbanctech.ru/v.yelagin/etrcollectionmodel"
  s.license          = 'MIT'
  s.author           = { "Vadim Yelagin" => "v.yelagin@eastbanctech.ru" }
  s.source           = { :git => "https://gitlab.eastbanctech.ru/v.yelagin/etrcollectionmodel.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/'
  s.resource_bundles = {
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreData'
  s.dependency 'ReactiveCocoa', '~> 2.3'
end
