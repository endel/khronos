require 'socket'
TCP_NEW = TCPSocket.method(:new) unless defined? TCP_NEW

#
# Example:
#   mock_tcp_next_request("<xml>junk</xml>")
#
class FakeTCPSocket
  def puts(*args); end
  def closed?; true; end
  def write(some_text = nil); end
end

def mock_tcp_next_request(string)
  TCPSocket.stub!(:new).and_return {
    cm = FakeTCPSocket.new
    cm
  }
end

def unmock_tcp
  TCPSocket.stub!(:new).and_return { TCP_NEW.call }
end
