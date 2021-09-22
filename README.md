# lab3

在lab3中，我们需要实现`TCPSender`。

`TCPSender`负责接收对方发送的`TCPSegment`中的ack号和接收窗口大小（first unassembled索引和first unacceptable索引的距离），应用层通过socket将字节流写入`TCPSender`中的`ByteStream`，`TCPSender`根据接收到的`ackno`和`window size`，从`ByteStream`中读取出来，将`ByteStream`中的字节流转化为连续的`TCPsegment`，发送给对方。

而在接收方，`TCPReceiver`将收到的`TCPSegment`转化回原始的`ByteStream`中的字节流，并发送`ackno`和`window size`给sender。(这个lab2中实现了)


`TCPSender`要做的事情：

- 追踪`TCPReceiver`的接收窗口(处理收到的`ackno`和`window size`)
- 通过从`ByteStream`读取，创建新的`TCPsegment`（如果需要的话，包括SYN和FIN标志）并发送，尽可能地填满接收窗口。只有当接收窗口已满或`TCPsender`的`ByteStream`为空时，`TCPsender`才能停止发送segments。
- 追踪已发送但是没有收到`ackno`的segments，超时之后重新发送这些segments。

最后一部分是超时重传的内容，比较简单就不多说了了，看代码实现。

## fill_window()
TCPSender 被要求填充窗口：它从它的输入`ByteStream`中读取字节，然后构造成`TCPSegment`（加上SYN和FIN，并且占据序列号和空间）发送尽可能多的字节，只要ByteStream中有字节可以读取并且接收窗口有可用空间（window size> 0)发送窗口有空位。

我们发送的每一个TCPsegment的载荷要尽可能地大，但是不要超过TCPConfig::MAX_PAYLOAD_SIZE (1452字节，链路层MTU减去IP数据报首部和TCP报文段首部)

我们可以使用`TCPSegment::length_in_sequence_space()`方法计算出一个segment所占据的序列号的长度，如果segment中包括SYN和FIN标志位，也需要各占据一个序列号。segment存储在发送窗口中，所以SYN和FIN在发送窗口也需要占据空间。

注意，如果`TCPReceiver`返回的ack segment中的window size为0，那么 fill_windows()方法将window size视为1，TCPsender会发送一个被接收方拒绝（并且未确认）的字节，这样会促使接收方发送一个新的ack segment，从而表明此时的window size的大小。 如果不这样，即使接收窗口有空闲的空间了，发送者也不知道它可以再次开始发送。

```cpp
void TCPSender::fill_window() {

    // 设置SYN
    if (!_syn_sent) {
        TCPSegment seg;
        _syn_sent = true;
        seg.header().syn = true;
        _send_segments(seg);
        return;
    }

    // 设置过FIN直接返回
    if (_fin_sent) {
        return;
    }

    _receiver_free_space = _receive_window_size > _bytes_in_flight ? _receive_window_size - _bytes_in_flight : 0;
    if(_stream.eof() && _receiver_free_space >= 1){
        TCPSegment seg;
        _fin_sent = true;
        seg.header().fin = true;
        _send_segments(seg);
        return;
    }

    _receiver_free_space = _receive_window_size - _bytes_in_flight;
    while(!_stream.buffer_empty() && _receiver_free_space > 0){
        TCPSegment seg;

        size_t payload_size = min(_stream.buffer_size(), min(_receiver_free_space, TCPConfig::MAX_PAYLOAD_SIZE));
        seg.payload() = _stream.read(payload_size);
        // 有空间的话就带上FIN
        if(_stream.eof() && _receiver_free_space > seg.length_in_sequence_space()){
            seg.header().fin = true;
            _fin_sent = true;
        }

        _send_segments(seg);
        _receiver_free_space = _receive_window_size - _bytes_in_flight;
    }

}

void TCPSender::_send_segments(TCPSegment &seg){
    seg.header().seqno = next_seqno();

    _next_seqno += seg.length_in_sequence_space();
    _bytes_in_flight += seg.length_in_sequence_space();

    // 发送
    _segments_out.push(seg);
    _sent_segments.push(seg);

    // 启动重传定时器
    if (!_timer_started) {
        _timer_started = true;
        _timer_countdown = _RTO;
    }
}
```

## ack_received()
接收到从`TCPReceiver`返回的ack segments，提取出其中的ackno和window size，**TCPsender需要将发送窗口中seqno小于ackno的segments删除**，根据window size调整发送窗口的大小，调用 fill_windows()继续传送。

```cpp
void TCPSender::ack_received(const WrappingInt32 ackno, const uint16_t window_size) {
    uint64_t abs_ackno = unwrap(ackno, _isn, _next_seqno);
    // 接收到还没发送的直接返回
    if (abs_ackno > _next_seqno) {
        return;
    }

    // 更新接收窗口
    _receive_window_size = window_size == 0 ? 1 : window_size;
    _back_off = window_size != 0;

    // 接收过了就直接返回
    if (abs_ackno <= _latest_abs_ackno) {
        return;
    }

    // 清理已经发送并确认的segment
    while (!_sent_segments.empty()) {
        TCPSegment seg = _sent_segments.front();
        uint64_t abs_seq = unwrap(seg.header().seqno, _isn, _next_seqno);
        if (abs_seq + seg.length_in_sequence_space() <= abs_ackno) {
            _sent_segments.pop();
            _bytes_in_flight -= seg.length_in_sequence_space();

            // 更新重传定时器
            _RTO = _initial_retransmission_timeout;
            _timer_countdown = _RTO;
            _consecutive_retransmissions = 0;
        } else {
            break;
        }
    }

    _latest_abs_ackno = abs_ackno;

    if (_sent_segments.empty()) {
        _timer_started = false;
        _timer_countdown = _RTO;
    }
}
```

## tick()
每隔几毫秒，`TCPSender`的 tick 方法将自动被调用（不需要我们调用），并带有一个参数，该参数告诉它自上次调用该方法以来已经过去了多少毫秒，使用它来维护`TCPSender`一直存活的总毫秒数。我们只需要在 tick 中实现，通过参数判断过去了多少时间，需要执行何种操作即可。

```cpp
void TCPSender::tick(const size_t ms_since_last_tick) {
    if (!_timer_started) {
        return;
    }

    _timer_countdown -= ms_since_last_tick;
    if (_timer_countdown > 0) {
        return;
    }

    std::cout << "timeout: " << ms_since_last_tick << std::endl;

    // 重新传送最早的且未被确认的segment
    _segments_out.push(_sent_segments.front());

    if (_receive_window_size > 0 && _back_off) {
        _consecutive_retransmissions++;
        // 指数回退
        _RTO *= 2;
    }

    _timer_countdown = _RTO;
}

```


## 测试
```sh
$ make check_lab3
[100%] Testing the TCP sender...
Test project /media/sf_share/sponge/build
      Start  1: t_wrapping_ints_cmp
 1/33 Test  #1: t_wrapping_ints_cmp ..............   Passed    0.00 sec
      Start  2: t_wrapping_ints_unwrap
 2/33 Test  #2: t_wrapping_ints_unwrap ...........   Passed    0.01 sec
      Start  3: t_wrapping_ints_wrap
 3/33 Test  #3: t_wrapping_ints_wrap .............   Passed    0.00 sec
      Start  4: t_wrapping_ints_roundtrip
 4/33 Test  #4: t_wrapping_ints_roundtrip ........   Passed    0.15 sec
      Start  5: t_recv_connect
 5/33 Test  #5: t_recv_connect ...................   Passed    0.00 sec
      Start  6: t_recv_transmit
 6/33 Test  #6: t_recv_transmit ..................   Passed    0.05 sec
      Start  7: t_recv_window
 7/33 Test  #7: t_recv_window ....................   Passed    0.00 sec
      Start  8: t_recv_reorder
 8/33 Test  #8: t_recv_reorder ...................   Passed    0.01 sec
      Start  9: t_recv_close
 9/33 Test  #9: t_recv_close .....................   Passed    0.01 sec
      Start 10: t_recv_special
10/33 Test #10: t_recv_special ...................   Passed    0.01 sec
      Start 11: t_send_connect
11/33 Test #11: t_send_connect ...................   Passed    0.01 sec
      Start 12: t_send_transmit
12/33 Test #12: t_send_transmit ..................   Passed    0.07 sec
      Start 13: t_send_retx
13/33 Test #13: t_send_retx ......................   Passed    0.02 sec
      Start 14: t_send_window
14/33 Test #14: t_send_window ....................   Passed    0.03 sec
      Start 15: t_send_ack
15/33 Test #15: t_send_ack .......................   Passed    0.01 sec
      Start 16: t_send_close
16/33 Test #16: t_send_close .....................   Passed    0.02 sec
      Start 17: t_send_extra
17/33 Test #17: t_send_extra .....................   Passed    0.01 sec
      Start 18: t_strm_reassem_single
18/33 Test #18: t_strm_reassem_single ............   Passed    0.01 sec
      Start 19: t_strm_reassem_seq
19/33 Test #19: t_strm_reassem_seq ...............   Passed    0.01 sec
      Start 20: t_strm_reassem_dup
20/33 Test #20: t_strm_reassem_dup ...............   Passed    0.01 sec
      Start 21: t_strm_reassem_holes
21/33 Test #21: t_strm_reassem_holes .............   Passed    0.01 sec
      Start 22: t_strm_reassem_many
22/33 Test #22: t_strm_reassem_many ..............   Passed    0.52 sec
      Start 23: t_strm_reassem_overlapping
23/33 Test #23: t_strm_reassem_overlapping .......   Passed    0.00 sec
      Start 24: t_strm_reassem_win
24/33 Test #24: t_strm_reassem_win ...............   Passed    0.59 sec
      Start 25: t_strm_reassem_cap
25/33 Test #25: t_strm_reassem_cap ...............   Passed    0.09 sec
      Start 26: t_byte_stream_construction
26/33 Test #26: t_byte_stream_construction .......   Passed    0.00 sec
      Start 27: t_byte_stream_one_write
27/33 Test #27: t_byte_stream_one_write ..........   Passed    0.01 sec
      Start 28: t_byte_stream_two_writes
28/33 Test #28: t_byte_stream_two_writes .........   Passed    0.00 sec
      Start 29: t_byte_stream_capacity
29/33 Test #29: t_byte_stream_capacity ...........   Passed    0.41 sec
      Start 30: t_byte_stream_many_writes
30/33 Test #30: t_byte_stream_many_writes ........   Passed    0.01 sec
      Start 53: t_address_dt
31/33 Test #53: t_address_dt .....................   Passed    0.03 sec
      Start 54: t_parser_dt
32/33 Test #54: t_parser_dt ......................   Passed    0.01 sec
      Start 55: t_socket_dt
33/33 Test #55: t_socket_dt ......................   Passed    0.01 sec

100% tests passed, 0 tests failed out of 33

Total Test time (real) =   2.40 sec
[100%] Built target check_lab3
```

继续lab4！！
