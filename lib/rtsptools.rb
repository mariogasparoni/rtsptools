require 'socket'
require 'uri'
require 'base64'

##
# rtsptools is a simple module for testing RTSP media sources.
# Initiallly, this is intended to be used by applications that need to
# constantly check the status of RTSP media sources, such as IP Cameras.
#
# Author::    Mario Gasparoni Jr  (mailto:mario@mgasp.info)
# License::   GNU General Public License 2 (GPL-2.0)
module RTSPTools

    ##
    # RTSPConnectionTester is a simple class to test RTSP connectivity.
    # This was intended to be used by applications that need to constantly
    # check the status of RTSP media sources, such as IP Cameras.
    #
    class RTSPConnectionTester
        attr_reader :uri, :host, :port, :timeout, :logging #:nodoc:
        LOG = "[logger] - " #:nodoc:
        LOG_WARNING = LOG + "WARNING: " #:nodoc:

        #RTSP user agent
        USER_AGENT = "RTSPConnectionTester-beta" #:nodoc:
        #Current RTSP version
        RTSP_VERSION = 1.0 #:nodoc:
        #RTSP status code OK
        RTSP_STATUS_CODE_OK = 200 #:nodoc:

        #RTSP Successfull response string
        RTSP_SUCCESSFULL_RESPONSE_LINE =
            "RTSP/#{RTSP_VERSION} #{RTSP_STATUS_CODE_OK} OK\r\n" #:nodoc:

        #Default connection timeout
        DEFAULT_TIMEOUT = 5
        #Default RTSP port
        RTSP_DEFAULT_PORT = 554

        ## Creates an RTSPConnectionTester instance.
        # ==== Params
        #
        # * +:uri+ - An RTSP URI to be tested
        # * +:timeout+ - A timeout for connection test
        # * +:logging+ - Set this flag to enable logging
        #
        # === Alternative params
        #
        # Instead of passing an RTSP URI, you can pass the following parameters,
        # for testing port connectivity only
        # * +:host+ - The media source host
        # * +:port+ - The media source port
        def initialize(params = {})
            @uri = params[:uri]
            @cseq = 0
            if @uri
                @p_uri = URI(@uri)
                @host = @p_uri.host
                @port = @p_uri.port || RTSP_DEFAULT_PORT
            else
                @host = params[:host]
                @port = params[:port] || RTSP_DEFAULT_PORT
            end
            raise ArgumentError.new("Missing arguments") unless @host
            @timeout = params[:timeout] || DEFAULT_TIMEOUT
            @logging = params[:logging]
        end

        ##
        # Test connectivity against media source..
        # When deep_check is set, RTSP protocol is check using OPTIONS
        # message. This method blocks until finishes it test, or timeout
        # exceeds
        #
        # ==== Options
        #
        # * +:deep_check+
        # Set this flag to test connectivity using OPTIONS
        # message. You must set an RTSP URI to use this option
        def test_rtsp_connectivity(options = {})
            @deep_check = options[:deep_check]
            initialize_socket()
            begin
                @socket.connect_nonblock(@saddress)
            rescue IO::WaitWritable
                if IO.select([@socket],[@socket],nil,@timeout)
                    begin
                        @socket.connect_nonblock(@saddress)
                    rescue Errno::EISCONN
                    rescue => error
                        @socket.close
                        raise error
                    end
                else
                    @socket.close
                    raise "Error: connection timed out after #{@timeout} seconds"
                end
            end

            result = true

            if (@deep_check)
                if (@p_uri)
                    send_options_message()
                    if RTSP_SUCCESSFULL_RESPONSE_LINE != @socket.gets
                        result = false
                    end
                else
                    if @logging
                        puts LOG_WARNING + "skipping deep_check, since no " \
                        "RTSP uri was given"
                    end
                end
            end

            @socket.close
            return result
        end

        private

            def initialize_socket
                @socket = Socket.new(Socket::AF_INET,Socket::SOCK_STREAM,0)
                @saddress = Socket.sockaddr_in(@port,@host)
            end

            def send_options_message
                @cseq = @cseq + 1
                options_message = "OPTIONS #{@uri} RTSP/1.0\r\n" \
                    "CSeq: #{@cseq}\r\n" \
                    "User-Agent: #{USER_AGENT}\r\n"

                if @p_uri.userinfo
                    options_message = options_message +
                    "Authorization: Basic " + Base64.encode64(@p_uri.userinfo) + "\r\n"
                end

                options_message = options_message + "\r\n"
                @socket.write(options_message)
            end

            attr_accessor :socket, :saddress, :cseq, :user_agent
    end
end


