
# https://github.com/hadley/devtools/wiki/Testing

# this allows tests to run without actually running an ActiveMQ server
host <- "vm://localhost?broker.persistent=false&broker.deleteAllMessagesOnStartup=true&broker.useJmx=false&jms.prefetchPolicy.queuePrefetch=1";
#host <- "tcp://ag-clo-ampbuild:61616";
queue <- "amq-prodcon-test-queue";
type <- "activeMQ";
#host <- "tcp://ag-clo-ampbuild:61616";

context("producer consumer");

# should clean out the message queue first


# test full cycle, put a message in and retrieve it
test_that("producer can produce a message, consumer can consume it", {
	# open consumer...
	consumer.queue = messageQueue.factory.getConsumerFor(host, queue, type);
	
	# ensure the queue is clear... (should be)
	messageQueue.consumer.clearQueue(consumer.queue);
	
	

	# drop a message onto the queue
	producer.queue = messageQueue.factory.getProducerFor(host, queue, type);
	status <- messageQueue.producer.putText(producer.queue, "test-message-1", correlationId = "c1", replyTo = "r2");
	expect_equal(status, 1);
	
	
	# close producer
	#status <- messageQueue.producer.close(producer.queue);
	#expect_equal(status, 1);
	
	Sys.sleep(1);


	
	checks <- 1;
	consumer.message <- messageQueue.consumer.getNextText(consumer.queue);
	while (is.null(consumer.message) && checks < 10) {
		Sys.sleep(1);
		consumer.message <- messageQueue.consumer.getNextText(consumer.queue);
		checks <- checks + 1;
	}
	expect_true(!is.null(consumer.message),info=paste("message: '",consumer.message,"'", sep=""));
	
	
	
	expect_true(!is.null(consumer.message$value));
	expect_equal(consumer.message$value, "test-message-1", info=paste("actual value: '", consumer.message$value,"'", sep=""));
	
	expect_true(!is.null(consumer.message$correlationId));
	expect_equal(consumer.message$correlationId,"c1");

	expect_true(!is.null(consumer.message$replyTo), info=paste("value: '",consumer.message$replyTo, "'", sep=""));
	expect_equal(consumer.message$replyTo, "r2");
	
	
	
	expect_true(status > 0, label="status isn't greater than 0", info=paste("status = ",status, sep=""));
	
	
	# cleanup the queue afterwards
	messageQueue.consumer.clearQueue(consumer.queue);

	# close queue
	status <- messageQueue.consumer.close(consumer.queue);
	expect_equal(status, 1);
})
