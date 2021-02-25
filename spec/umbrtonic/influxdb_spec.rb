# frozen_string_literal: true

RSpec.describe Umbrtonic::InfluxDB do
  specify "values" do
    influx = Umbrtonic::InfluxDB.new("test")

    expect(influx.data)
      .to eq(values: {}, tags: {}, series: "test")

    influx.values a: 2, c: 3
    influx.value :a, 1

    expect(influx.data[:values])
      .to eq(a: 1, c: 3)
  end

  specify "tags" do
    influx = Umbrtonic::InfluxDB.new("test")

    influx.tag :z, 6
    influx.tag :z, 1
    influx.tags x: 3, y: 3

    expect(influx.data[:tags])
      .to eq(z: 1, x: 3, y: 3)
  end
end
