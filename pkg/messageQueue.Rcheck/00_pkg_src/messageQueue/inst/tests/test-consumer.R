
# https://github.com/hadley/devtools/wiki/Testing

# this allows tests to run without actually running an ActiveMQ server
host <- "vm://localhost?broker.persistent=false&broker.deleteAllMessagesOnStartup=true&broker.useJmx=false&jms.prefetchPolicy.queuePrefetch=1";
queue <- "amq-consumer-test-queue";
type <- "activeMQ";
#host <- "tcp://ag-clo-ampbuild:61616";

context("consumer");

test_that("consumer connects to a queue", {
	consumer.queue = messageQueue.factory.getConsumerFor(host, queue, type);
	expect_true(!is.null(consumer.queue));
	
	status <- messageQueue.consumer.close(consumer.queue);
	expect_equal(status, 1);
})

test_that("consumer can close a queue", {
	consumer.queue = messageQueue.factory.getConsumerFor(host, queue, type);
	expect_true(!is.null(consumer.queue));
	expect_true(messageQueue.consumer.close(consumer.queue) > 0);
})
			

# queue should be empty
test_that("consumer retrieves no messages. ", {
	consumer.queue = messageQueue.factory.getConsumerFor(host, queue, type);
	
	# cleanup the queue first..
	messageQueue.consumer.clearQueue(consumer.queue);

	consumer.message <- messageQueue.consumer.getNextText(consumer.queue);
	cat(paste("consumer.message:",consumer.message,",", typeof(consumer.message),"\n",sep=""));
	expect_true(is.null(consumer.message), label="Empty message", info=paste("message:",consumer.message,sep=""));

	status <- messageQueue.consumer.close(consumer.queue);
	expect_equal(status, 1);
})
