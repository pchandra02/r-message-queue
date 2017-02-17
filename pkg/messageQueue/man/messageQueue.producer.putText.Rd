\name{messageQueue.producer.putText}
\alias{messageQueue.producer.putText}
\title{
Put a text message on a queue
}
\description{
For a producer bound to a queue, put a text message into that queue.
}
\usage{
status <- messageQueue.producer.putText(producer, text)
}
\arguments{
  \item{producer}{
The producer object created from \code{\link{messageQueue.factory.getProducerFor}}
}
  \item{text}{
The text message to put onto the queue
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
\keyword{ put }
\keyword{ producer }