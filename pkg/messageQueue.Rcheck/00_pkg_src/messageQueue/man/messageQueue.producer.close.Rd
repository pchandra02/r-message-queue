\name{messageQueue.producer.close}
\alias{messageQueue.producer.close}
\title{
Close a producer of a queue
}
\description{
Closes and releases memory reserved when this producer was created.

When a queue producer is created, objects are created in the background
and exist for the lifetime of that producer.  Explicitly closing the
producer safely deallocates memory and restores natural order to
the world.
}
\usage{
status <- messageQueue.producer.close(producer)
}
\arguments{
  \item{producer}{
The producer object created from \code{\link{messageQueue.factory.getProducerFor}}
}
}
\details{
.
}
\value{
Returns a positive number (i.e. > 0) if it was successful.
Returns a negative number (i.e. < 0) if it was unsuccessful.
}
\references{
.
}
\author{
Matt MacGillivray
}
\note{
.
}

\seealso{
\code{\link{messageQueue.factory.getProducerFor}}
}
\examples{
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

}
\keyword{ messagequeue }
\keyword{ message }
\keyword{ queue }
\keyword{ mq }
\keyword{ close }
\keyword{ consumer }