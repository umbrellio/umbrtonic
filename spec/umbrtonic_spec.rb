# frozen_string_literal: true

RSpec.describe Umbrtonic do
  let(:socket) { double("socket") }
  let(:uuid)   { SecureRandom.uuid }
  let(:prefix) { "super" }
  let(:host)   { "127.0.0.1" }
  let(:port)   { 4444 }

  before do
    Timecop.freeze

    allow(Umbrtonic).to receive(:socket) { socket }

    described_class.configure do |conf|
      conf.influxdb.host = host
      conf.influxdb.port = port

      conf.prefix = prefix
    end
  end

  specify ".bind" do
    expect(socket).to receive(:send).with(
      "#{prefix}_#{uuid},label=prod view_runtime=150i,db_runtime=10i", 0, host, port
    )

    described_class.bind(uuid) do |inf, event, payload|
      expect(event).to   be_kind_of(ActiveSupport::Notifications::Event)
      expect(inf).to     be_kind_of(Umbrtonic::InfluxDB)
      expect(payload).to eq(event.payload)

      inf.values view_runtime: payload[:view_runtime], db_runtime: payload[:db_runtime]
      inf.tags label: payload[:label]
    end

    ActiveSupport::Notifications.instrument(uuid, view_runtime: 150, db_runtime: 10, label: :prod)
  end

  specify "use payload from event directly" do
    expect(socket).to receive(:send).with(
      "#{prefix}_#{uuid} view_runtime=150i", 0, host, port
    )

    described_class.bind(uuid) do |inf, event|
      inf.values view_runtime: event.payload[:view_runtime]
    end

    ActiveSupport::Notifications.instrument(uuid, view_runtime: 150)
  end
end
