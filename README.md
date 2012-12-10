# SpecMarker - RSpec formatter that useful for profiling

## Installation

Add this line to your application's Gemfile:

    gem 'spec_marker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spec_marker

## Usage

### Basic

```
# to STDOUT
$ rspec --format SpecMarker ...

# to a File
$ rspec --format SpecMarker --out spec_marker.log ...
$ cat spec_marker.log
```

### Log File

Log file is like this:

```
[suite:start][1355121779.69578] {"tag":"suite","at":1355121779.6957781,"meta":{},"kind":"start"}
[example_group:start][1355121779.69596] {"tag":"example_group","at":1355121779.695959,"meta":{"description":"foo"},"kind":"start"}
[example:start][1355121779.69616] {"tag":"example","at":1355121779.6961558,"meta":{"location":"./a_spec.rb:2","description":"hello"},"kind":"start"}
[example:end][1355121781.69764 (2.00148)] {"tag":"example","at":1355121781.6976361,"meta":{"location":"./a_spec.rb:2","description":"hello","result":"passed"},"kind":"end","elapsed":2.0014803409576416}
...
```

Each line is:

```
[TAG][TIMESTAMP (ELAPSED TIME)] JSON
```

### Marking

``` ruby
describe "foo" do
  it "hello" do
    sleep 2
  end

  context "bar" do
    it "hello" do
      # Use SpecMarker.mark to mark the time on the log.
      SpecMarker.mark :foo
      #=> [foo][1355121541.62746] {"tag":"foo","at":1355121541.627462,"meta":{},"kind":null}

      # You can pass additional data to record in JSON.
      SpecMarker.mark :foo, meta: :data
      #=> [foo][1355121541.62750] {"tag":"foo","at":1355121541.627502,"meta":{"meta":"data"},"kind":null}
    end

    it "hello" do
      # You can record an elapsed time of any parts.
      SpecMarker.mark :bar, :start
      #=> [bar:start][1355121781.69903] {"tag":"bar","at":1355121781.699029,"meta":{},"kind":"start"}
      sleep 1

      # Then call with :end to record elapsed time.
      SpecMarker.mark :bar, :end
      #=> [bar:end][1355121782.70022 (1.00119)] {"tag":"bar","at":1355121782.700217,"meta":{},"kind":"end","elapsed":1.001188039779663}
      sleep 1
    end

    it "hello" do
      # You can also pass the metadata.
      SpecMarker.mark :bar, {meta: :data}, :start
      SpecMarker.mark :bar, {meta: :data}, :end
    end
  end
end
```
