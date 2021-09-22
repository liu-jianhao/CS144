#include "tcp_sender.hh"

#include "tcp_config.hh"

#include <random>
#include <iostream>

// Dummy implementation of a TCP sender

// For Lab 3, please replace with a real implementation that passes the
// automated checks run by `make check_lab3`.

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

//! \param[in] capacity the capacity of the outgoing byte stream
//! \param[in] retx_timeout the initial amount of time to wait before retransmitting the oldest outstanding segment
//! \param[in] fixed_isn the Initial Sequence Number to use, if set (otherwise uses a random ISN)
TCPSender::TCPSender(const size_t capacity, const uint16_t retx_timeout, const std::optional<WrappingInt32> fixed_isn)
    : _isn(fixed_isn.value_or(WrappingInt32{random_device()()}))
    , _initial_retransmission_timeout{retx_timeout}
    , _stream(capacity)
    , _bytes_in_flight(0)
    , _receive_window_size(1)
    , _receiver_free_space(0)
    , _RTO(retx_timeout)
    , _timer_started(false)
    , _timer_countdown(retx_timeout)
    , _consecutive_retransmissions(0)
    , _latest_abs_ackno(0)
    , _syn_sent(false)
    , _fin_sent(false)
    , _back_off(true) {}

uint64_t TCPSender::bytes_in_flight() const {
    return _bytes_in_flight;
}

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

//! \param ackno The remote receiver's ackno (acknowledgment number)
//! \param window_size The remote receiver's advertised window size
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

//! \param[in] ms_since_last_tick the number of milliseconds since the last call to this method
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

unsigned int TCPSender::consecutive_retransmissions() const {
    return _consecutive_retransmissions;
}

void TCPSender::send_empty_segment() {
    TCPSegment seg;
    seg.header().seqno = next_seqno();
    _segments_out.push(seg);
}
