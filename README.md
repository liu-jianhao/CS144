# lab2

这次是需要实现一个TCP Receiver。

完成lab2需要知道TCP的三次握手和四次挥手，代码量很少。

## 第一部分：wrapping_integers
需要重点理解下面这张图：



- seqno：在TCP传输的TCPsegment中的标志每个字节的序列号，从ISN开始，32位。
- absolute seqno：将seqno变为从0开始，64位。通过wrap和unwrap与seqno相互转换。
- stream indices：实际接受的字节流中每个字节的序列号，64位，即真正传输的数据的序列号（也就是我们在StreamReassembler中使用的索引，从0开始），FIN和SYN不占序列号

wrapping_intergers做的就是seqno和absolute_seqno的互相转换。

1. absolute seqno -> seqno
```cpp
WrappingInt32 wrap(uint64_t n, WrappingInt32 isn) {
    return WrappingInt32{uint32_t (n + isn.raw_value())};
}
```
加上isn就完事了。
2. seqno -> absolute seqno
```cpp
uint64_t unwrap(WrappingInt32 n, WrappingInt32 isn, uint64_t checkpoint) {
    WrappingInt32 wrap_checkpoint = wrap(checkpoint, isn);
    int32_t diff = n - wrap_checkpoint;
    int64_t res = checkpoint + diff;
    if (res < 0) {
        return res + (1ul << 32);
    }
    return res;
}
```
这里有个坑就是res变成负数的情况，需要加上一个2的32次方。


跑测试：
```sh
$ ctest -R wrap
Test project /media/sf_share/sponge/build
    Start 1: t_wrapping_ints_cmp
1/4 Test #1: t_wrapping_ints_cmp ..............   Passed    0.04 sec
    Start 2: t_wrapping_ints_unwrap
2/4 Test #2: t_wrapping_ints_unwrap ...........   Passed    0.00 sec
    Start 3: t_wrapping_ints_wrap
3/4 Test #3: t_wrapping_ints_wrap .............   Passed    0.01 sec
    Start 4: t_wrapping_ints_roundtrip
4/4 Test #4: t_wrapping_ints_roundtrip ........   Passed    0.56 sec

100% tests passed, 0 tests failed out of 4

Total Test time (real) =   0.80 sec
```

## 第二部分：tcp_receiver
TCPReceiver负责：
- 从对方接受 TCPSegment
- 使用StreamReassembler重新组装字节流
- 计算ackno 和 window size，它们最后被发送回对方

下图是TCPsegment的格式，是网络层的IP数据报的载荷部分。非灰色的字段是这个lab关注的部分

由TCPsender发送，被TCPReceiver接收的部分：
- 序列号seqno
- SYN and FIN flags
- Payload
由TCPReceiver发送，被TCPsender接收的部分：
- ackno
- window size

了解了这些之后，我们其实只要重点判断syn和fin标志，哪些情况需要接收数据（交给StreamReassembler），哪些时候不需要。

需要加上这三个私有成员变量：
```cpp
    size_t _isn;
    bool _syn;
    bool _fin;
```

```cpp
void TCPReceiver::segment_received(const TCPSegment &seg) {
    if (!_syn && !seg.header().syn) {
        return;
    }
    if (_syn && seg.header().syn) {
        return;
    }

    if (seg.header().syn) {
        _syn = true;
        _isn = seg.header().seqno.raw_value();
    }

    if (_syn && seg.header().fin) {
        _fin = true;
    }

    size_t abs_seqno = unwrap(seg.header().seqno, WrappingInt32(_isn), _reassembler.stream_out().bytes_written());
    uint64_t stream_index = seg.header().syn ? 0 : abs_seqno - 1;
    _reassembler.push_substring(seg.payload().copy(), stream_index, seg.header().fin);
}

optional<WrappingInt32> TCPReceiver::ackno() const {
    if (!_syn) {
        return {};
    }

    if (_fin && _reassembler.unassembled_bytes() == 0) {
        return wrap(_reassembler.stream_out().bytes_written() + 2, WrappingInt32(_isn));
    }
    return wrap(_reassembler.stream_out().bytes_written() + 1, WrappingInt32(_isn));
}

size_t TCPReceiver::window_size() const {
    return _reassembler.stream_out().remaining_capacity();
}
```
可以看出来，代码并不复杂。

跑测试：
```sh
$ make check_lab2
[100%] Testing the TCP receiver...
Test project /media/sf_share/sponge/build
      Start  1: t_wrapping_ints_cmp
 1/26 Test  #1: t_wrapping_ints_cmp ..............   Passed    0.00 sec
      Start  2: t_wrapping_ints_unwrap
 2/26 Test  #2: t_wrapping_ints_unwrap ...........   Passed    0.01 sec
      Start  3: t_wrapping_ints_wrap
 3/26 Test  #3: t_wrapping_ints_wrap .............   Passed    0.00 sec
      Start  4: t_wrapping_ints_roundtrip
 4/26 Test  #4: t_wrapping_ints_roundtrip ........   Passed    0.38 sec
      Start  5: t_recv_connect
 5/26 Test  #5: t_recv_connect ...................   Passed    0.01 sec
      Start  6: t_recv_transmit
 6/26 Test  #6: t_recv_transmit ..................   Passed    0.10 sec
      Start  7: t_recv_window
 7/26 Test  #7: t_recv_window ....................   Passed    0.01 sec
      Start  8: t_recv_reorder
 8/26 Test  #8: t_recv_reorder ...................   Passed    0.01 sec
      Start  9: t_recv_close
 9/26 Test  #9: t_recv_close .....................   Passed    0.02 sec
      Start 10: t_recv_special
10/26 Test #10: t_recv_special ...................   Passed    0.01 sec
      Start 17: t_strm_reassem_single
11/26 Test #17: t_strm_reassem_single ............   Passed    0.02 sec
      Start 18: t_strm_reassem_seq
12/26 Test #18: t_strm_reassem_seq ...............   Passed    0.01 sec
      Start 19: t_strm_reassem_dup
13/26 Test #19: t_strm_reassem_dup ...............   Passed    0.01 sec
      Start 20: t_strm_reassem_holes
14/26 Test #20: t_strm_reassem_holes .............   Passed    0.02 sec
      Start 21: t_strm_reassem_many
15/26 Test #21: t_strm_reassem_many ..............   Passed    1.31 sec
      Start 22: t_strm_reassem_overlapping
16/26 Test #22: t_strm_reassem_overlapping .......   Passed    0.01 sec
      Start 23: t_strm_reassem_win
17/26 Test #23: t_strm_reassem_win ...............   Passed    1.38 sec
      Start 24: t_strm_reassem_cap
18/26 Test #24: t_strm_reassem_cap ...............   Passed    0.17 sec
      Start 25: t_byte_stream_construction
19/26 Test #25: t_byte_stream_construction .......   Passed    0.01 sec
      Start 26: t_byte_stream_one_write
20/26 Test #26: t_byte_stream_one_write ..........   Passed    0.01 sec
      Start 27: t_byte_stream_two_writes
21/26 Test #27: t_byte_stream_two_writes .........   Passed    0.00 sec
      Start 28: t_byte_stream_capacity
22/26 Test #28: t_byte_stream_capacity ...........   Passed    0.99 sec
      Start 29: t_byte_stream_many_writes
23/26 Test #29: t_byte_stream_many_writes ........   Passed    0.01 sec
      Start 52: t_address_dt
24/26 Test #52: t_address_dt .....................   Passed    0.05 sec
      Start 53: t_parser_dt
25/26 Test #53: t_parser_dt ......................   Passed    0.00 sec
      Start 54: t_socket_dt
26/26 Test #54: t_socket_dt ......................   Passed    0.01 sec

100% tests passed, 0 tests failed out of 26

Total Test time (real) =   4.85 sec
[100%] Built target check_lab2
```
完成。