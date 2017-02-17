# Vision:  A generic interface to basic queue functionality in R.
#
# Currently supports activeMQ and rabbitMQ.
#
# Author: matthew.macgillivray@cornell.edu
#
###############################################################################


.onLoad <-
	function(libname, pkgname) {
		.jpackage(pkgname, lib.loc = libname)
	}


# Make a connection to a queue, and generate a consumer for it.
#
# Returns the consumer instance, null if the connection couldn't be established
#
# url: url to the host machine
# queue: name of the queue
# queueType: activeMQ, rabbitMQ
factory.getConsumerFor <- function(url, queue, queueType) {
		require(futile.logger);

		# call the MessageQueueFactory.getConsumerFor static method

		if (queueType == "activeMQ" || queueType == "activemq" || queueType == "rabbitmq" || queueType == "rabbitMQ") {
			# static call
			consumer <- .jcall(J("edu/cornell/clo/r/message_queue/MessageQueueFactory"), "Ledu/cornell/clo/r/message_queue/Consumer;","getConsumerFor", url, queue, queueType)

			if (is.null(consumer)) {
				flog.warn("WARNING: consumer is null.  Not sure why.", name="messageQueue");
			}
		} else {
			flog.error("ERROR: queueType must be one of (activeMQ, rabbitMQ), not: %s", queueType, name="messageQueue");
		}

		return(consumer);
	}



# Make a connection to a queue, and generate a producer for it.
#
# Returns: the producer instance, null if the connection couldn't be established
#
# url: url to the host machine
# queue: name of the queue
# queueType: activeMQ, rabbitMQ
factory.getProducerFor <- function(url, queue, queueType) {
		require(futile.logger);
		# call the MessageQueueFactory.getConsumerFor static method

		if (tolower(queueType) == "activemq" || tolower(queueType) == "rabbitmq") {
			# static call
			producer <- .jcall(J("edu/cornell/clo/r/message_queue/MessageQueueFactory"), "Ledu/cornell/clo/r/message_queue/Producer;","getProducerFor", url, queue, queueType)

			if (is.null(producer)) {
				flog.warn("WARNING: producer is null.  Not sure why.", name="messageQueue");
			}
		} else {
			flog.error("ERROR: queueType must be one of (activeMQ, rabbitMQ), not: %s", queueType, name="messageQueue");
		}

		return(producer);
	}


# Check for a message on the queue.
# Non-blocking
consumer.getNextText <- function(consumer) {
		require(futile.logger);

		smessage = NULL;
		if (!is.null(consumer)) {
			flog.debug(" before 'getNextText'", name="messageQueue");
			message <- .jcall(consumer, "Ledu/cornell/clo/r/message_queue/STextMessage;", "getNextText");

			# decode from java.lang.String objects to R strings
			if (!is.null(message)) {
				flog.debug("message retrieved", name="messageQueue");
				smessage <- list("value" = .jstrVal(message$value), "correlationId" = .jstrVal(message$correlationId), "replyTo" = .jstrVal(message$replyTo));

				flog.trace("retrieved message$value: '%s', correlationId: '%s', replyTo: '%s'", smessage$value, smessage$correlationId, smessage$replyTo, name="messageQueue");

			} else {
				flog.debug("no message retrieved status: %s", consumer$lastStatusCode, name="messageQueue");
				smessage = NULL;
				return(NULL);
			}

			# this fancy, nice syntax doesn't seem to work
			if (consumer$lastStatusCode < 0) {
				flog.debug(consumer$getStatusString(consumer$lastStatusCode), name="messageQueue");
			}
		} else {
			flog.debug("ERROR: consumer is null.", name="messageQueue");
			smessage = NULL;
			return(NULL);
		}
		return(smessage);
	}




# EXCLUSIVELY used for testing
consumer.clearQueue <- function(consumer) {
		require(futile.logger);

		if (!is.null(consumer)) {
			flog.debug(" clearing queue...", name="messageQueue");

			i <- 0;
			# loop until the queue is empty
			repeat {
				message <- .jcall(consumer, "Ledu/cornell/clo/r/message_queue/STextMessage;", "getNextText");

				# 3 null messages? break..
				if (is.null(message)) {
					i <- i+1;
					if (i > 2) {
						break;
					}
				}
			}
			flog.debug(" clearing queue... done", name="messageQueue");
		}
	}




# Close the consumer, deallocate resources.
# Non-blocking
consumer.close <- function(consumer) {
		require(futile.logger);

		if (!is.null(consumer)) {
			status <- .jcall(consumer, "I", "close")

			# this fancy, nice syntax doesn't seem to work
			if (status < 0) {
				flog.debug("[messageQueue.consumer.close] status: %s", consumer$getStatusString(status), name="messageQueue");
			}
		} else {
			flog.debug("ERROR: consumer is null.", name="messageQueue");
			status = -5;
		}
		return(status);
	}



# Add the following text to the noted queue
# Non-blocking
#
# result codes:
# -5: producer is null
# -4: session is null, can't create a message (in java)
# -2: JMS exception trying to send the message (in java)
# -1: unknown error
#  1: success
producer.putText <- function(producer, text, correlationId = "", replyToQueue = "") {
		require(futile.logger);

		if (!is.null(producer) && !is.null(text)) {
			status <- .jcall(producer, "I", "putText", text, correlationId, replyToQueue)

			if (status < 0) {
				flog.debug("[messageQueue.producer.putText] stautus: %s", producer$getStatusString(status), name="messageQueue");
			}
		} else {
			flog.debug("ERROR: producer is null, or text is null.", name="messageQueue");
			status = -5;
		}
		return(status);
	}




# Close the producer, deallocate resources.
# Non-blocking
producer.close <- function(producer) {
		require(futile.logger);

		if (!is.null(producer)) {
			status <- .jcall(producer, "I", "close")

			if (status < 0) {
				flog.debug("[messageQueue.producer.close] status: %s", producer$getStatusString(status), name="messageQueue");
			}
		} else {
			flog.debug("ERROR: producer is null.", name="messageQueue");
			status = -5;
		}
		return(status);
	}



# BEGINNING DEV, building out the basic structure/documentation
# R> package.skeleton(name="messageQueue", code_files=c("messageQueue.R"), list=c("messageQueue.factory.getProducerFor", "messageQueue.producer.close", "messageQueue.producer.putText", "messageQueue.factory.getConsumerFor", "messageQueue.consumer.close", "messageQueue.consumer.getNextText"))

# CHECKING/TESTING: running tests, ensuring the package structure is fine, run from the messageQueue's parent directory:
# R CMD check --no-multiarch messageQueue

# BUILDING, creating ZIP or tar.gz file for distribution:
# R CMD INSTALL --no-multiarch --build messageQueue
