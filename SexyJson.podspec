Pod::Spec.new do |s|
  s.name         = "SexyJson"
  s.version      = "0.0.3"
  s.summary      = "SexyJson is Swift3.+ json parse open quickly and easily, perfect supporting class and struct model, support the KVC model"

  s.homepage     = "https://github.com/netyouli/SexyJson"

  s.license      = "MIT"

  s.author             = { "吴海超(WHC)" => "712641411@qq.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/netyouli/SexyJson.git", :tag => "0.0.3"}

  s.source_files  = "SexyJsonKit/*.{swift}"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true


end
