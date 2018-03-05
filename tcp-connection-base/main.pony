use "net"
use "time"

actor Main
  new create(env: Env) =>
    try
      TCPListener(env.root as AmbientAuth,
        Listener(env.out),
        "",
        "7669")
    else
      env.out.print("unable to use the network")
    end

class Listener is TCPListenNotify
  let _out: OutStream
  var _host: String = ""
  var _port: String = ""

  new iso create(out: OutStream) =>
    _out = out

  fun ref listening(listen: TCPListener ref) =>
    try
      (_host, _port) = listen.local_address().name()?
      _out.print("listening on " + _host + ":" + _port)
    else
      _out.print("couldn't get local address")
      listen.close()
    end

  fun ref not_listening(listen: TCPListener ref) =>
    _out.print("couldn't listen")
    listen.close()

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    Server(_out)

class Server is TCPConnectionNotify
  let _out: OutStream
  var started_at: I64 = 0
  var ended_at: I64 = 0
  var bytes_received: USize = 0

  new iso create(out: OutStream) =>
    _out = out

  fun ref accepted(conn: TCPConnection ref) =>
    _out.print("connection accepted")
    started_at = Time.seconds()

  fun ref received(conn: TCPConnection ref, data: Array[U8] iso,
    times: USize): Bool
  =>
    bytes_received = bytes_received + data.size()
    true

  fun ref closed(conn: TCPConnection ref) =>
    ended_at = Time.seconds()
    _out.print("server closed")
    let bytes_per_second = bytes_received.i64() / (ended_at - started_at)
    _out.print("Bytes received per second: " + bytes_per_second.string())

  fun ref connect_failed(conn: TCPConnection ref) =>
    _out.print("connect failed")
