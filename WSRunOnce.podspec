Pod::Spec.new do |s|

  s.name         = "WSRunOnce"
  s.version      = "1.0.0"
  s.summary      = "A facility to make run once operation more simple."

  s.homepage     = "https://github.com/Shunzi007/WSRunOnce"
  s.license      = "MIT"
  

  s.author             = { "王顺" => "360752546@qq.com" }
  s.ios.deployment_target = "5.0"
  
  s.source       = { :git => "https://github.com/Shunzi007/WSRunOnce.git", :tag => s.version.to_s }

  s.source_files  = "WSRunOnce/*.{h,m}"
  
  s.framework  = "Foundation"

end
