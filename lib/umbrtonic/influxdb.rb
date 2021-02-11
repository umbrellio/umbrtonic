# frozen_string_literal: true

class Umbrtonic::InfluxDB
  def initialize(measurement, values: {}, tags: {})
    @measurement = measurement
    @values      = values
    @tags        = tags
  end

  def values(**values)
    @values = values
  end

  def tags(**tags)
    @tags = tags
  end

  def data
    { values: @values,
      tags: @tags,
      series: series }
  end

  def to_str
    ::InfluxDB::PointValue.new(data).dump
  end

  private

  def series
    prefix = Umbrtonic.config.settings.prefix

    if prefix
      "#{prefix}_#{@measurement}"
    else
      @measurement.to_s
    end
  end
end
