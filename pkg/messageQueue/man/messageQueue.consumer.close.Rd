\name{messageQueue.consumer.close}
\alias{messageQueue.consumer.close}
\title{
Close a consumer of a queue
}
\description{
Closes and releases memory reserved when this consumer was created.

When a queue consumer is created, objects are created in the background
and exist for the lifetime of that consumer.  Explicitly closing the
consumer safely deallocates memory and restores natural order to
the world.
}
\usage{
status <- messageQueue.consumer.close(consumer)
}
\arguments{
  \item{consumer}{
The consumer object created from \code{\link{messageQueue.factory.getConsumerFor}}
}
}
\details{
Closes a consumer.
}
\value{
Returns a positive number (i.e. > 0) if it was successful.
Returns a negative number (i.e. < 0) if it was unsuccessful.
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

# ... do some stuff ...

# close the consumer
status <- messageQueue.consumer.close(queueAconsumer)

}
\keyword{ messagequeue }
\keyword{ message }
\keyword{ queue }
\keyword{ mq }
\keyword{ close }
\keyword{ consumer }