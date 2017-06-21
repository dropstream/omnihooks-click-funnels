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

def read_request(file_name)
  File.open(File.expand_path("../../../fixtures/#{file_name}.json", __FILE__)).read
end

RSpec.describe OmniHooks::Strategies::ClickFunnelsTest do
  include Mail::Matchers

  let(:app) do
    lambda { |_env| [404, {}, ['Awesome']] }
  end


  describe '#options' do
    subject { OmniHooks::Strategies::ClickFunnelsTest.new(nil) }

    it 'should have a name defined' do
      expect(subject.options.name).to eq('sendgrid-parse')
    end
  end

  describe '#args' do
    it 'has expected arguments' do
      expect(OmniHooks::Strategies::ClickFunnelsTest.args).to eq([])
    end
  end

  describe '#call' do
    let(:strategy) { OmniHooks::Strategies::ClickFunnelsTest.new(app) }

    context 'with a matched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).to receive(:call).with(an_email)

        strategy.call(make_env('/hooks/click-funnels', multipart_fixture('matching_event')))
      end

      it 'should have received an e-mail' do
        expect(strategy.call(make_env('/hooks/click-funnels', multipart_fixture('matching_event')))).to have_sent_email
      end   

      it 'should have matching properties' do
        expect(strategy.call(make_env('/hooks/click-funnels', multipart_fixture('matching_event')))).to have_sent_email.to('test@webhooks.getdropstream.com').matching_body('')
      end  
      
    end
  
    context 'with a matched event containg an attachment' do
      it 'should have received an e-mail with attachment' do
        expect(strategy.call(make_env('/hooks/click-funnels', multipart_fixture('matching_event_with_attachements')))).to have_sent_email.with_any_attachments
      end
    end

    context 'with an unmatched event' do
      it 'should pass the event to the subscriber' do
        expect(subscriber).not_to receive(:call)

        strategy.call(make_env('/hooks/click-funnels', multipart_fixture('unmatching_event')))
      end
    end
  
  end
end  
end