Pod::Spec.new do |s|

  s.name         = "ProgressScrollView"
  s.version      = "0.0.8"
  s.summary      = "Compilation of views that show remote content"

  s.homepage     = "https://ramotion.com"

  s.license      = {:type => "All rights reserved", :text => "All rights reserved"}

  s.author       = { "Kolpachkov Igor" => "i.kolpachkov@gmail.com" }
 
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/TalntsApp/TalntsProgressScrollView.git", :tag => "0.0.8" }

  s.source_files  = "ProgressScrollView", "ProgressScrollView/ProgressScrollView/**/*.{h,m,swift}"

  s.requires_arc = true

  s.frameworks = 'UIKit'

end