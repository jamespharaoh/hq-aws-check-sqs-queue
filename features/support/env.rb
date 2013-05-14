require "hq/cucumber/command"
require "hq/cucumber/temp-dir"

require "hq/aws/check-sqs-queue/script"

$commands["hq-aws-check-sqs-queue"] =
	HQ::AWS::CheckSqsQueue::Script
