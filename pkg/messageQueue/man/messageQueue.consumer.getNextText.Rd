\name{messageQueue.consumer.getNextText}
\alias{messageQueue.consumer.getNextText}
\title{
Retrieve the next available text message
}
\description{
For a consumer of a queue, retrieve the next available text message on a queue.

If the next message isn't in text format, it will be skipped and the next message
will be checked.

This is a non-blocking method, that is, it will not wait for a message to appear.
If no messages are available in the queue (it's empty), this method will return null.
}
\usage{
messageText <- messageQueue.consumer.getNextText(consumer)
}
\arguments{
  \item{consumer}{
The consumer object created from \code{\link{messageQueue.factory.getConsumerFor}}
}
}
\details{
Retrieves the next available text message in a queue.
}
\value{
Returns non-null text if it was successful.
Returns null if no messages were received.
}
\author{
Matt MacGillivray
}
\note{
.
}

\seealso{
\code{\link{messageQueue.factory.getConsumerFor}}
}
\examples{
# NORMALLY, this url would be of the form 'tcp://host:61616', but for testing, activeMQ provides
# a local/internal queue that works by default
queueUrl <- "vm://localhost?broker.persistent=false"

# create a queue consumer
queueAconsumer <- messageQueue.factory.getConsumerFor(queueUrl,"queueA","activeMQ")

# retrieve the next available text message
textMessage <- messageQueue.consumer.getNextText(queueAconsumer)

# ... do some stuff ...

# close the consumer
status <- messageQueue.consumer.close(queueAconsumer)

}
\keyword{ messagequeue }
\keyword{ message }
\keyword{ queue }
\keyword{ mq }
\keyword{ consume }