use "collections"
use "net"

actor Main
  new create(env: Env) =>
    try
      let connect_to_ip = env.args(1)?
      let connect_to_port = env.args(2)?
      let msgs_per_send = env.args(3)?.u64()?.usize()

      let data_chunk = FramedDataCreator(msgs_per_send)
      let sender = Sender(env.out, env.err, data_chunk)

      try
        TCPConnection(env.root as AmbientAuth,
          consume sender,
          connect_to_ip,
          connect_to_port)
      else
        env.err.print("Unable to send")
      end
    else
      env.err.print("Bad command line options")
    end

class Sender is TCPConnectionNotify
  let _out: OutStream
  let _err: OutStream
  let _data_chunk: Array[U8] val

  new iso create(out: OutStream, err: OutStream, data_chunk: Array[U8] val) =>
    _out = out
    _err = err
    _data_chunk = data_chunk

  fun ref connected(conn: TCPConnection ref) =>
    """
    We've connected! Start blasting data!
    """
    conn.write(_data_chunk)

  fun ref sent(conn: TCPConnection ref, data: ByteSeq): ByteSeq =>
    """
    Queue another send AND send this data by returning it
    """
    conn.write(_data_chunk)
    data

  fun ref connect_failed(conn: TCPConnection ref) =>
    _err.print("Unable to connect")

primitive FramedDataCreator
  fun apply(msgs: USize = 10, length: U32 = 48): Array[U8] val =>
    let s = msgs * (length.usize() + 4)
    let a: Array[U8] iso = recover iso Array[U8].init(87, s) end
    let h = header_bytes(length)

    recover
      let a' = consume ref a
      h.copy_to(a', 0, 0, 4)
      a'
    end

  fun header_bytes(length: U32): Array[U8] val =>
    Bytes.from_u32(length)
