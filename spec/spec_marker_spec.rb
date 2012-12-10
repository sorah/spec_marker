require 'spec_helper'
require 'spec_marker'
require 'stringio'
require 'json'

describe SpecMarker do
  let(:output) { StringIO.new }
  let(:formatter) do
    SpecMarker.new(output).tap do |formatter|
      formatter.start(2)
    end
  end

  let(:time) { Time.now }

  before do
    Time.stub(now: time)
  end

  subject { output.string.split(/\n/) }

  describe "marking" do
    let(:example_group1) { RSpec::Core::ExampleGroup.describe }
    let(:example1_1) { RSpec::Core::ExampleGroup.example }
    let(:example1_2) { RSpec::Core::ExampleGroup.example }

    let(:example_group2) { RSpec::Core::ExampleGroup.describe }
    let(:example2_1) { RSpec::Core::ExampleGroup.example }

    before do
      formatter.example_group_started(example_group1)
      formatter.example_started(example1_1)
      Time.stub(now: Time.now + 10)
      formatter.example_passed(example1_1)
      formatter.example_started(example1_2)
      formatter.example_failed(example1_1)
      formatter.example_group_finished(example_group1)
      formatter.example_group_started(example_group2)
      formatter.example_started(example2_1)
      formatter.example_pending(example2_1)
      formatter.example_group_finished(example_group2)
    end

    it { should have(10).lines }

    it "records JSON per line" do
      expect {
        subject.each { |line| JSON.parse(line) }
      }.to_not raise_error
    end

    it "records timestamp" do
      json = JSON.parse(subject[0])
      json['at'].should == time.to_f
      json['elapsed'].should == 10
    end
  end

  describe "data" do
    before do
      formatter.example_group_started(example_group)
      formatter.example_started(example)
      SpecMarker.mark(:foo, {meta: :data})
      SpecMarker.mark(:bar, {meta: :meta}, :start)
      SpecMarker.mark(:bar, {meta: :meta}, :end)
      SpecMarker.mark(:bar, {meta: :foo}, :start)
      SpecMarker.mark(:bar, {meta: :foo}, :end)
      SpecMarker.mark(:bar) do
      end
      formatter.example_passed(example)
      formatter.example_group_finished(example_group)
    end

    it { should have(11).lines }
  end
end
