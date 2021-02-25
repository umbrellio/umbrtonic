# frozen_string_literal: true

class Umbrtonic::InfluxDB
  def initialize(measurement, values: {}, tags: {})
    @measurement = measurement
    @values      = values
    @tags        = tags
  end

  def value(name, value)
    @values[name] = value
  end

  def values(**values)
    @values = @values.merge(**values)
  end

  def tag(name, value)
    @tags[name] = value
  end

  def tags(**tags)
    @tags = @tags.merge(**tags)
  end

  def data
    { values: @values,
      tags: @tags,
      series: series }
  end

  def build
    ::InfluxDB::PointValue.new(data).dump
  end

  private

  def series
    [Umbrtonic.config.settings.prefix, @measurement].compact.join("_")
  end
end
