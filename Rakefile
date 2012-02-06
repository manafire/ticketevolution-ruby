require 'rake'
require 'rubygems'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

namespace :documentation do
  desc 'builds README.markdown'
  task :build do
    require 'ticket_evolution'
    require 'nokogiri'

    def load_doc(file)
      File.read(TicketEvolution.root + "../docs/#{file}.markdown")
    end

    contents = StringIO.new

    # Introduction
    contents << load_doc('introduction')

    # Installation
    contents << load_doc('installation')

    # Connection
    contents << load_doc('objects')

    # Endpoints
    contents << load_doc('endpoints')

    endpoints_connection = Curl::Easy.new('http://developer.ticketevolution.com/endpoints.xml')
    endpoints_connection.http_get
    endpoints_xml = Nokogiri::XML(endpoints_connection.body_str)

    endpoints_xml.xpath('//endpoint').sort_by{|x| x.xpath('name').children.to_s}.each do |xml|
      presenter = ThisTask::EndpointPresenter.new(xml)
      contents << "
**#{presenter.name}** - [#{presenter.url}](#{presenter.url})
#{presenter.examples}
"
    end
    contents << "

######ticketevolution-ruby v#{TicketEvolution::VERSION}"
    contents.rewind
    File.open(TicketEvolution.root + '../../README.markdown', 'w+') do |f|
      f.write contents.read
    end
  end
end

module ThisTask
  class EndpointPresenter
    def initialize(xml)
      @xml = xml
    end

    def name
      get(@xml, 'name')
    end

    def chain_name
      underscore(name)
    end

    def examples
      case chain_name
      when "addresses", "email_addresses", "phone_numbers", "credit_cards"
        actions_for("@client")
      when "transactions"
        actions_for("@account")
      else
        actions_for("@connection")
      end
    end

    def actions_for(base)
      actions.collect do |action|
        action_name = underscore(get(action, 'name'))
        "
    #{variable} = #{formatted_action(base, action_name)}"
      end.join
    end

    def formatted_action(base, name)
      case name
      when "show"
        "#{base}.#{chain_name}.#{name}(id)"
      when "update"
        "#{variable}.#{name}(params)"
      when "accept_order", "reject_order"
        "#{variable}.#{name.gsub('_order', '')}(params)"
      when "complete_order"
        "#{variable}.#{name.gsub('_order', '')}"
      else
        "#{base}.#{chain_name}.#{name}(params)"
      end
    end

    def url
      "http://developer.ticketevolution.com/endpoints/#{get(@xml, 'slug')}"
    end

    def variable
      "@#{chain_name.singularize}"
    end

    def underscore(str)
      str.gsub(' ', '').underscore
    end

    def get(subject, part)
      subject.xpath(part).children.to_s
    end

    def actions
      @xml.xpath('endpoint-action').xpath('endpoint-action').sort_by{|a| a.xpath('name').children.to_s}
    end
  end
end
