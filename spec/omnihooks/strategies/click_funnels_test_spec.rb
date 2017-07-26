require 'spec_helper'

def make_env(path = '/hooks/funnel_webhooks/test', props = {})
  {
    'REQUEST_METHOD' => 'POST',
    'PATH_INFO' => path,
    "CONTENT_TYPE" => 'application/json',
    'rack.session' => {},
    'rack.input' => StringIO.new('test=true'),
  }.merge(props)
end

def fixture(file_name)
  data = File.open(File.expand_path("../../../fixtures/#{file_name}.json", __FILE__)).read
  length = data.bytesize

  { 
    "CONTENT_TYPE" => 'application/json',
    "CONTENT_LENGTH" => length.to_s,
    'rack.input' => StringIO.new(data) 
  }  
end

RSpec.describe OmniHooks::Strategies::ClickFunnelsTest do

  let(:app) do
    lambda { |_env| [404, {}, ['Awesome']] }
  end


  describe '#options' do
    subject { OmniHooks::Strategies::ClickFunnelsTest.new(nil) }

    it 'should have a name defined' do
      expect(subject.options.name).to eq('funnel_webhooks/test')
    end
  end

  describe '#args' do
    it 'has expected arguments' do
      expect(OmniHooks::Strategies::ClickFunnelsTest.args).to eq([])
    end
  end

  describe '#call' do
    let(:subscriber) { Proc.new { |s| s } }
    let(:strategy) { OmniHooks::Strategies::ClickFunnelsTest.new(app) }

    before(:each) do
      OmniHooks::Strategies::ClickFunnelsTest.configure do |events|
        events.subscribe('test', subscriber)
      end
    end

    context 'with a matched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).to receive(:call)

        strategy.call(make_env('/hooks/funnel_webhooks/test', fixture('test_event')))
      end
    end   
  end  
end