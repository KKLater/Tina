Pod::Spec.new do |s|

  s.name         = "Tina"
  s.version      = "0.0.1"
  s.summary      = "A request fonundation with Swift for mac、ios、watchos、tvos."

  s.description  = <<-DESC
                   Tina is a simple and pure Swift implemented library for request. It is  dependent on Alamofire. It provides you a chance to use pure Swift alternation in your next app.
                   DESC

  s.homepage     = "https://github.com/KKLater/Tina"
  # s.screenshots  = ""

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors      = { "KKLater" => "lshxin89@126.com" }

  s.swift_version = "5.0"
  s.swift_versions = ['5.0']

  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.watchos.deployment_target = "3.0"

  s.source       = { :git => "https://github.com/KKLater/Tina.git", :tag => s.version }

  s.source_files  = ["Sources/**/*.swift", "Sources/Tina.h"]

  s.requires_arc = true
  s.dependency 'Alamofire', '~>5.4.0'
end
