require 'spec_helper'

describe RTSPTools::RTSPConnectionTester do

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path", timeout: 5)
        it "takes the URI and timeout and should return an Object" do
            expect(rtspctest).to be_an_instance_of RTSPTools::RTSPConnectionTester
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(host: "127.0.0.1",
            port: 8554, timeout: 5)
        it "takes the host,port and timeout and should return an Object" do
            expect(rtspctest).to be_an_instance_of RTSPTools::RTSPConnectionTester
        end
    end

    describe "#new" do
        it "misses uri and host arguments" do
            expect {
                rtspctest = RTSPTools::RTSPConnectionTester.new(timeout: 5,
                logging: true)
            }.to raise_error(ArgumentError)
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path", timeout: 10)
        it "expects host and rtsp default port from URI" do
            expect(rtspctest).to have_attributes(:host => "127.0.0.1",
                :port => RTSPTools::RTSPConnectionTester::RTSP_DEFAULT_PORT)
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path", timeout: 10)
        it "expects timeout" do
            expect(rtspctest).to have_attributes(:timeout => 10)
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path")
        it "expects default timeout" do
            expect(rtspctest).to have_attributes(:timeout =>
                RTSPTools::RTSPConnectionTester::DEFAULT_TIMEOUT)
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path" , logging: true)
        it "expects to set logging" do
            expect(rtspctest).to have_attributes(:logging => true)
        end
    end

    describe "#new" do
        rtspctest = RTSPTools::RTSPConnectionTester.new(
            uri: "rtsp://user:pass@127.0.0.1/path")
        it "expects default logging" do
            expect(rtspctest).to have_attributes(:logging => nil)
        end
    end
end
