# frozen_string_literal: true

require "active_support/notifications"
require "influxdb/point_value"
require "socket"
require "qonfig"

module Umbrtonic
  require_relative "umbrtonic/influxdb"
  require_relative "umbrtonic/version"

  include Qonfig::Configurable

  configuration do
    setting :influxdb do
      setting :host, "127.0.0.1"
      setting :port, 8089
    end

    setting :prefix
  end

  module_function

  def bind(name, measurement: name)
    ActiveSupport::Notifications.subscribe(name) do |*args|
      event  = ActiveSupport::Notifications::Event.new(*args)
      influx = Umbrtonic::InfluxDB.new(measurement)

      yield influx, event, event.payload
      send_via_udp influx
    end
  end

  def send_via_udp(influx)
    config = self.config.settings.influxdb
    socket.send(influx.to_str, 0, config.host, config.port)
  end

  def socket
    @socket ||= UDPSocket.new
  end
end
