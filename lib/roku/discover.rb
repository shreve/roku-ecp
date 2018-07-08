require 'socket'

module Roku
  module Discover
    MULTICAST_ADDR = '239.255.255.250'.freeze
    BIND_ADDR = '0.0.0.0'.freeze
    PORT = 1900
    REQUEST = "M-SEARCH * HTTP/1.1\n" \
              "Host: 239.255.255.250:1900\n" \
              "Man: \"ssdp:discover\"\n" \
              "ST: roku:ecp\n\n".freeze

    class DeviceNotFound < StandardError
    end

    class << self
      def search
        bind
        socket.send(REQUEST, 0, MULTICAST_ADDR, PORT)
        begin
          parse_address(await_response)
        rescue Timeout::Error
          raise DeviceNotFound, "Roku's automatic device discovery failed. " \
                                "If you continue to receive this message, " \
                                "you may want to manually configure this. " \
                                "You can do this by finding the device's IP " \
                                "via your router and setting the ROKU_HOST " \
                                "environment variable to " \
                                "\"http://{{device-ip}}:8060\"."
        end
      end

      def await_response
        Timeout.timeout(10) do
          loop do
            response, = socket.recvfrom(1024)
            if response.include?('LOCATION') && response.include?('200 OK')
              return response
            end
          end
        end
      end

      private

      def bind
        return if @bound
        socket.bind(BIND_ADDR, PORT)
        @bound = true
      end

      def parse_address(response)
        response.scan(/LOCATION: (.*)\r/).first.first
      end

      def socket
        @socket ||= UDPSocket.open.tap do |socket|
          socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, bind_address)
          socket.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
          socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
        end
      end

      def bind_address
        IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton
      end
    end
  end
end
