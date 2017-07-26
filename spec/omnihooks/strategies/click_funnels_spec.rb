require 'spec_helper'

def make_env(path = '/hooks/click-funnels', props = {})
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

RSpec.describe OmniHooks::Strategies::ClickFunnels do

  let(:app) do
    lambda { |_env| [404, {}, ['Awesome']] }
  end


  describe '#options' do
    subject { OmniHooks::Strategies::ClickFunnels.new(nil) }

    it 'should have a name defined' do
      expect(subject.options.name).to eq('click-funnels')
    end
  end

  describe '#args' do
    it 'has expected arguments' do
      expect(OmniHooks::Strategies::ClickFunnels.args).to eq([])
    end
  end

  describe '#call' do
    let(:subscriber) { Proc.new { |s| s } }
    let(:strategy) { OmniHooks::Strategies::ClickFunnels.new(app) }

    before(:each) do
      OmniHooks::Strategies::ClickFunnels.configure do |events|
        events.subscribe('purchase_created', subscriber)
      end
    end

    context 'with a matched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).to receive(:call)

        strategy.call(make_env('/hooks/click-funnels', fixture('purchase_created_event')))
      end
    end
    context 'with an unmatched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).not_to receive(:call)

        strategy.call(make_env('/hooks/click-funnels', fixture('contact_created_event')))
      end
    end    
  end  
end