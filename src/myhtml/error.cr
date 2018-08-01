# Exception for errors raised by this shard.
class Myhtml::Error < Exception
end

# Raised when trying to enter not exist node
class Myhtml::EmptyNodeError < Myhtml::Error
end
