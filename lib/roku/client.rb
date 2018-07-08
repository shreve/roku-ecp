require 'httparty'

module Roku
  module Client
    include HTTParty
    format :xml

    KEYS = %i[
      Home
      Rev
      Fwd
      Play
      Select
      Left
      Right
      Down
      Up
      Back
      InstantReplay
      Info
      Backspace
      Search
      Enter
      FindRemote
      VolumeDown
      VolumeMute
      VolumeUp
      PowerOff
      InputTuner
      InputHDMI1
      InputHDMI2
      InputHDMI3
      InputHDMI4
      InputAV1
    ].freeze

    class << self
      def find_device!
        address = ENV.fetch('ROKU_HOST') { Roku::Discover.search }
        base_uri(address)
      end

      def apps
        get('/query/apps').parsed_response['apps']['app'].map do |app|
          App.parse(app)
        end
      end

      def active_app
        app = get('/query/active-app').parsed_response['active_app']['app']
        App.parse(app)
      end

      def device_info
        get('/query/device-info').parsed_response['device_info']
      end

      def tv_channels
        get('/query/tv-channels').parsed_response['tv_channels']
      end

      def tv_active_channel
        get('/query/tv-active-channel').parsed_response['tv_channel']
      end

      def launch(app_id)
        post("/launch/#{app_id}").success?
      end

      def install(app_id)
        post("/install/#{app_id}").success?
      end

      def send_text(string)
        string.split('').map do |c|
          next if c == ' '
          post("/keypress/#{c}").success?
        end.all?
      end

      def keypress(key)
        return unless KEYS.include?(key.to_sym)
        post("/keypress/#{key}").success?
      end

      def keydown(key)
        return unless KEYS.include?(key.to_sym)
        post("/keydown/#{key}").success?
      end

      def keyup(key)
        return unless KEYS.include?(key.to_sym)
        post("/keyup/#{key}").success?
      end

      def input(options = {})
        post('/input', options)
      end
    end
  end
end
