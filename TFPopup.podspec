

Pod::Spec.new do |s|
s.name         = "TFPopup"
s.version      = "0.3.0"
s.ios.deployment_target = '7.0'
s.summary      = "A powerful pop-up tool"
s.homepage     = "https://github.com/shmxybfq/TFPopup"
s.license      = "MIT"
s.author             = { "ZTF" => "927141965@qq.com" }
s.social_media_url   = "http://www.jianshu.com/u/8c1cc9143ec6"
s.source       = { :git => "https://github.com/shmxybfq/TFPopup.git", :tag => s.version }
s.source_files  = "TFPopup/*.{h,m}"
s.requires_arc = true
end
