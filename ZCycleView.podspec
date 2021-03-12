Pod::Spec.new do |s|

s.name         = "ZCycleView"                              
s.version      = "0.0.8"
s.summary      = "轮播图"
s.homepage     = "https://github.com/MQZHot/ZCycleView"
s.author       = { "MQZHot" => "mqz1228@163.com" }   
s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" } 
s.requires_arc = true 
s.platform     = :ios, "9.0"    
                 
s.source       = { :git => "https://github.com/MQZHot/ZCycleView.git", :tag => s.version }
s.source_files  =["Source/*.{swift}"]  
             
end
