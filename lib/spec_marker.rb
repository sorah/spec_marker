require 'rubygems'
require 'rspec/core/formatters/base_formatter'
require 'json'

class SpecMarker < RSpec::Core::Formatters::BaseFormatter
  VERSION = "0.0.2"

  class << self
    def mark(*args)
      @listeners ||= []
      @listeners.each do |listener|
        listener.mark *args
      end
      self
    end

    def _join(formatter)
      @listeners ||= []
      @listeners << formatter unless @listeners.include?(formatter)
    end

    def _leave(formatter)
      (@listeners ||= []).delete formatter
    end
  end

  def initialize(*args)
    super
    @marks = []
  end

  def start(example_count)
    super
    self.class._join(self)
    mark :suite, :start
  end

  def stop
    super
    self.class._leave(self)
    mark :suite, :end
  end

  def mark(tag, meta_or_kind={}, kind=nil, meta_for_search=nil)
    if meta_or_kind.is_a?(Hash)
      meta = meta_or_kind
    elsif kind.nil? && meta_or_kind.is_a?(Symbol)
      meta = {}
      kind = meta_or_kind
    end

    m = {:tag => tag, :at => Time.now.to_f, :meta => meta, :kind => kind}
    if kind == :end
      start = @marks.reverse_each.find { |mark| mark[:kind] == :start && mark[:tag] == tag && mark[:meta] == (meta_for_search || meta)}
      if start
        m[:elapsed] = m[:at] - start[:at]
      end
    end

    @marks << m
    output.puts "[#{tag}#{kind && ":#{kind}"}][#{"%.5f" % m[:at]}#{m[:elapsed] && (" (%.5f)" % m[:elapsed])}] #{m.to_json}"
  end

  def example_group_started(group)
    super
    mark :example_group, example_group_meta(group), :start
  end

  def example_started(example)
    super
    mark :example, example_meta(example), :start
  end

  def example_passed(example)
    super
    mark :example, example_meta(example, :passed), :end, example_meta(example)
  end

  def example_pending(example)
    super
    mark :example, example_meta(example, :pending), :end, example_meta(example)
  end

  def example_failed(example)
    super
    mark :example, example_meta(example, :failed), :end, example_meta(example)
  end

  def example_group_finished(group)
    super
    mark :example_group, example_group_meta(group), :end
  end

  private

  def example_group_meta(group)
    {:description => group.description}
  end

  def example_meta(example, result = nil)
    {:location => example.location, :description => example.description}.merge(result ? {:result => result} : {})
  end
end
