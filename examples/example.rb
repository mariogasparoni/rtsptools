require 'rtsptools'

begin
    rtsp = RTSPTools::RTSPConnectionTester.new(uri: 'rtsp://admin:pass@example.com:port/path', timeout: 3)
    if rtsp.test_rtsp_connectivity(deep_check: true) #blocking
        puts "Your RTSP media source seems to be alive!"
    else
        puts "Err.. your media source failed at the connectivity test."
    end
rescue SocketError
    puts "Can't reach host: socket error"
rescue Errno::ECONNREFUSED
    puts "Connection refused"
rescue => error
    puts "#{error}"
end
