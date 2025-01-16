
Pod::Spec.new do |s|
  s.name             = 'DMErrorHandling'
  s.version          = '0.1.0'
  s.summary          = 'Error handling SDK'
  s.swift_version    = '5.6'
  s.description      = <<-DESC
  
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/nikolay-dementiev/DMErrorHandling'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nikolay Dementiev' => 'nikolas.dementiev@gmail.com' }
  s.source           = { :git => 'https://github.com/nikolay-dementiev/DMErrorHandling.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'DMErrorHandling/Sources/**/*'
  
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['DMErrorHandling/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Sources/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
