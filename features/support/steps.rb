require "cucumber/rspec/doubles"

Before do

	sqs_double = double "sqs"
	queues_double = double "queues"
	queue_double = double "queue"

	::AWS::SQS.stub(:new) do
		|opts|

		opts[:access_key_id].should == "access key id"
		opts[:secret_access_key].should == "secret access key"
		opts[:http_open_timeout].should == 10
		opts[:http_read_timeout].should == 10

		sqs_double

	end

	sqs_double.stub(:queues) do

		queues_double

	end

	queues_double.stub(:named) do
		|queue_name|

		queue_name.should == "queue"

		queue_double

	end

	queue_double
		.stub(:approximate_number_of_messages)
		.and_return { @messages_in_queue }

	queue_double
		.stub(:approximate_number_of_messages_delayed)
		.and_return { 0 }

	queue_double
		.stub(:approximate_number_of_messages_not_visible)
		.and_return { 0 }

end

Given /^the queue has (\d+) items$/ do
	|count_str|

	@messages_in_queue = count_str.to_i

end
