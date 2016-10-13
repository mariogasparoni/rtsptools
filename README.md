#RTSP tools for Ruby

##Description
rtsptools is a simple module for testing RTSP media sources.
Initiallly, this is intended to be used by applications that need to
constantly check the status of RTSP media sources, such as IP Cameras.

##Installation

Install it from rubygems.org
```
gem install rtsptools
```

Or you can build/install it yourself
```
gem build rtsptools.gemspec && gem install rtsptools-0.1.2.gem
```


##Usage
Simply add it to your application
```ruby
require 'rtsptools'
```

Testing RTSP connectivity
```ruby
begin
    rtspctest = RTSPTools::RTSPConnectionTester.new(
        uri: "rtsp://user:pass@127.0.0.1/path")

    if rtspctest.test_rtsp_connectivity(deep_check: true) #blocking
        puts "Your RTSP media source seems to be alive!"
    else
        puts "Err.. your media source failed at the connectivity test."
    end
rescue => error
    puts "#{error}"
end
```
