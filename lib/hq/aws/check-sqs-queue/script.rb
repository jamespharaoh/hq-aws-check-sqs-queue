require "aws-sdk"
require "xml"

require "hq/tools/check-script"
require "hq/tools/escape"
require "hq/tools/future"
require "hq/tools/getopt"
require "hq/tools/thread-pool"

module HQ
module AWS
module CheckSqsQueue

class Script < Tools::CheckScript

	include Tools::Escape

	def initialize
		super
		@name = "SQS queue"
	end

	def process_args

		@opts, @args =
			Tools::Getopt.process @args, [

				{ :name => :warning,
					:required => true,
					:convert => :to_i },

				{ :name => :critical,
					:required => true,
					:convert => :to_i },

				{ :name => :config,
					:required => true },

				{ :name => :account,
					:required => true },

				{ :name => :queue_name,
					:required => true },

			]

		@args.empty? \
			or raise "Extra args on command line"

	end

	def prepare

		config_doc =
			XML::Document.file \
				@opts[:config]

		@config =
			config_doc.root

		@account =
			@config.find_first "
				aws-account [
					@name = #{esc_xp @opts[:account]}
				]
			"

		raise "No such account" \
			unless @account

		@sqs =
			::AWS::SQS.new \
				:access_key_id =>
					@account.attributes["access-key-id"],
				:secret_access_key =>
					@account.attributes["secret-access-key"],
				:http_open_timeout => 10,
				:http_read_timeout => 10

	end

	def perform_checks

		queue =
			@sqs.queues.named @opts[:queue_name]

		message_count = [
			queue.approximate_number_of_messages,
			queue.approximate_number_of_messages_delayed,
			queue.approximate_number_of_messages_not_visible,
		].inject(:+)

		if message_count >= @opts[:critical]

			critical "%s messages (critical is %s)" % [
				message_count,
				@opts[:critical],
			]

		elsif message_count >= @opts[:warning]

			warning "%s messages (warning is %s)" % [
				message_count,
				@opts[:warning],
			]

		else

			message "%s messages" % [
				message_count,
			]

		end

	end

end

end
end
end
