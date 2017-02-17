\name{messageQueue-package}
\alias{messageQueue-package}
\alias{messageQueue}
\docType{package}
\title{
Allow R to put and get messages from message queues (activeMQ, rabbitMQ)
}
\description{
This package creates a simple way to interact with message queues regardless
of the underlying provider of the queue (activeMQ or rabbitMQ).

The idea is to provide this basic functionality such that R doesn't need to
deal with the specifics of queues or their underlying implementation differences.

Provides a simple way to PUT a text message on a queue and GET a text message
from a queue.
}
\details{
\tabular{ll}{
Package: \tab messageQueue\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-10-24\cr
License: \tab GPL\cr
}

.

}
\author{
Matt MacGillivray
Maintainer: Matt MacGillivray <matthew.macgillivray@cornell.edu>
}
\references{
RabbitMQ - http://www.rabbitmq.com/
ActiveMQ - http://activemq.apache.org/
rJava - http://www.rforge.net/rJava/
Writing Java Extensions - http://cran.r-project.org/web/packages/helloJavaWorld/vignettes/helloJavaWorld.pdf
}
\keyword{ package }
\keyword{ messagequeue }
\keyword{ message }
\keyword{ queue }
\keyword{ mq }
\keyword{ producer }
\keyword{ consumer }
\seealso{
}
\examples{
# Basic example using all functions
# NOTE: I can't get the example to run via the build server automatically, so I'm commenting it out

# NORMALLY, this url would be of the form 'tcp://host:61616', but for testing, activeMQ provides
# a local/internal queue that works by default
queueUrl <- "vm://localhost?broker.persistent=false"


# create a queue producer
queueAproducer <- messageQueue.factory.getProducerFor(queueUrl,"queueA","activeMQ")

# ... do some stuff ...

# put a message on the queue
textMessage <- "this is the message I want to send"
status <- messageQueue.producer.putText(queueAproducer, textMessage)

# close the producer
status <- messageQueue.producer.close(queueAproducer)



# create a queue consumer
queueAconsumer <- messageQueue.factory.getConsumerFor(queueUrl,"queueA","activeMQ")

# retrieve the next available text message
textMessage <- messageQueue.consumer.getNextText(queueAconsumer)
cat(textMessage)


# ... do some stuff ...

# close the consumer
status <- messageQueue.consumer.close(queueAconsumer)


}
