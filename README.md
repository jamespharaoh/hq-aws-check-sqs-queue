# HQ MongoDB check collection size

https://github.com/jamespharaoh/hq-aws-check-sqs-queue
https://rubygems.org/gems/hq-aws-check-sqs-queue

This project provides an icinga/nagios plugin to check the number of items in
an Amazon AWS SQS queue.

## Installation

For most use cases, simply install the ruby gem:

	gem install hq-aws-check-sqs-queue

You can also install the gem as part of a bundle and run it using the "bundle
exec" command.

	mkdir my-bundle
	cd my-bundle
	echo 'source "https://rubygems.org"' >> Gemfile
	echo 'gem "hq-aws-check-sqs-queue"' >> Gemfile
	bundle install --path gems

If you want to develop the script, clone the repository from github and use
bundler to satisfy dependencies:

	git clone git://github.com/jamespharaoh/hq-aws-check-sqs-queue.git
	cd hq-aws-check-sqs-queue
	bundle install --path gems

## Usage

If the gem is installed correctly, you should be able to run the command with
the following name:

	hq-aws-check-sqs-queue (options...)

If it was installed via bundler, then you will want to use bundler to invoke the
command correctly:

	bundle exec hq-aws-check-sqs-queue (options...)

You will also need to provide various options for the script to work correctly.

### General options

	--config PATH

The `--config` option specifies the configuration file, which should contain a
list of one or more AWS secret access keys. The format is described below.

### What to check

	--account NAME
	--queue-name NAME

The `--account` option specifies which credentials to select from the
configuration file.

The `--queue-name` account specifies the name of the queue to check and is
passed directly to AWS.

### Warning and critical thresholds

	--warning COUNT
	--critical COUNT

These options specify the levels at which to generate warnings.

## Configuration file

The configuration file stores details of AWS secret access keys. It is used to
obtain access to the information.

Here is a sample:

	<aws-accounts>

		<aws-account
			name="production"
			access-key-id="022QF06E7MXBSH9DHM02"
			secret-access-key="kWcrlUX5JEDGM/LtmEENI/aVmYvHNif5zB+d9+ct"/>

		<aws-account
			name="development"
			access-key-id="022QF06E7MXBSH9DHM02"
			secret-access-key="kWcrlUX5JEDGM/LtmEENI/aVmYvHNif5zB+d9+ct"/>

	</aws-accounts>
