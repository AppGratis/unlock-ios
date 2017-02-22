Pod::Spec.new do |s|

  s.name         = "AppGratis-unlock"
  s.module_name  = "AGUUnlock"
  s.version      = "0.6"
  s.summary      = "AppGratis Unlock Library - iOS"
  s.description  = <<-DESC
                  AppGratis Unlock Library - iOS Framework
                   DESC

  s.homepage     = "https://github.com/AppGratis/unlock-ios"
  s.license      = "MIT"
  s.author       = "AppGratis"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/AppGratis/unlock-ios.git", :tag => "#{s.version}" }
  s.source_files  = "Library/Unlock", "Library/Unlock/**/*.{h,m}"
  s.library   = "sqlite3"
  s.requires_arc = true

end
