
# https://github.com/hadley/devtools/wiki/Testing

# this allows tests to run without actually running an ActiveMQ server
host <- "vm://localhost?broker.persistent=false&broker.deleteAllMessagesOnStartup=true&broker.useJmx=false&jms.prefetchPolicy.queuePrefetch=1";
queue <- "amq-producer-test-queue";
type <- "activeMQ";
#host <- "tcp://ag-clo-ampbuild:61616";

context("producer");

test_that("producer connects to a queue", {
	producer.queue = messageQueue.factory.getProducerFor(host, queue, type);
	expect_false(is.null(producer.queue));
	
	messageQueue.producer.close(producer.queue);
})

test_that("producer can close a queue", {
	producer.queue = messageQueue.factory.getProducerFor(host, queue, type);
	expect_false(is.null(producer.queue));
	
	status <- messageQueue.producer.close(producer.queue);
	expect_equal(status, 1);
})
			

# producer should be able to create a message
test_that("producer can produce a message", {
	producer.queue = messageQueue.factory.getProducerFor(host, queue, type);
	consumer.queue = messageQueue.factory.getConsumerFor(host, queue, type);

	status <- messageQueue.producer.putText(producer.queue, "this is the message");
	expect_equal(status, 1);

	status <- messageQueue.producer.close(producer.queue);
	expect_equal(status, 1);

	Sys.sleep(5);

	# cleanup after
	messageQueue.consumer.clearQueue(consumer.queue);

	status <- messageQueue.producer.close(producer.queue);
	expect_equal(status, 1);
})

