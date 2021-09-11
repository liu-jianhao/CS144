#include "tcp_receiver.hh"

// Dummy implementation of a TCP receiver

// For Lab 2, please replace with a real implementation that passes the
// automated checks run by `make check_lab2`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

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
