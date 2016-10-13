require 'rtsptools'

begin
    rtsp = RTSPTools::RTSPConnectionTester.new(host: "example.com", port:8554, timeout: 10, logging:true)
    if rtsp.test_rtsp_connectivity() #blocking
        puts "Your RTSP media source seems to be alive!"
    else
        puts "Err.. your media source failed at the connectivity test."
    end
rescue => error
    puts "#{error}"
end
