\name{messageQueue.factory.getProducerFor}
\alias{messageQueue.factory.getProducerFor}
\title{
Connect to a queue for writing
}
\description{
Make a connection to a queue for writing.

The queue can be on a local, or remote host.
It is important to know what type of queue it is as the underlying
implementation details are different.  Currently, only 'activeMQ'
and 'rabbitMQ' are supported.

All connections should be closed when no longer needed.
}
\usage{
queueAproducer <- messageQueue.factory.getProducerFor(url, queue, queueType)
}
\arguments{
  \item{url}{
URL to the machine hosting the queue in the format 'tcp://<hostname>:<port>'
}
  \item{queue}{
Name of the queue (and/or topic) to connect to on that host.  The format of this
is dictated by the queue type you are connecting to.
}
  \item{queueType}{
What type of queue provider are you connecting to?  Required because each queue type
functions differently under the covers.

Supported Values: 'rabbitMQ' or 'activeMQ'
}
}
\details{
.
}
\value{
If successful, this method returns an object representing a producer for a queue.
If unsuccessful, this method returns null.
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
\code{\link{messageQueue.producer.close}}
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
\keyword{ connect }
\keyword{ producer }