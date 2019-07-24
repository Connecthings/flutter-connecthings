#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'herow'
  s.version          = '0.0.8'
  s.summary          = 'A flutter plugin for the Herow platform - https://my.herow.io'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://my.herow.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Connecthings' => 'contact@connecthings.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency  'HerowLocationDetection', '5.0.2'

  s.ios.deployment_target = '9.0'
end