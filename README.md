# CfErr

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'cf_err'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cf_err

## Usage

  CfErr.configure do |c|
    c.account = "sprout"
    c.project_id = 123
    c.auth_token = "abcdef"
    c.watch = {"NoMethodError" => 2, "ActionView::MissingTemplate" => 3}
  end

  errors_to_notify = CfErr.fetch

  module PagerDuty
    def trigger
      pg = Pagerduty.new('23668330dd3f012fb8442200023423')

      @errors.each do |e|
        pg.trigger("Airbrake Errors", :details => @error)
      end
    end
  end

  CfErr::Notifier.configure(PagerDuty)

  n = CfErr::Notifier.new(errors_to_notify)
  n.notify!

## TODO

  Got to support this DSL for adding new Providers

  Notifier.configure do |notifier|
    notifier.register_provider PagerDuty
    notifier.register_provider Twilio
  end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
