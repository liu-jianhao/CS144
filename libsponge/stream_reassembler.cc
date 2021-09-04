#include "stream_reassembler.hh"

// Dummy implementation of a stream reassembler.

// For Lab 1, please replace with a real implementation that passes the
// automated checks run by `make check_lab1`.

// You will need to add private members to the class declaration in `stream_reassembler.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

StreamReassembler::StreamReassembler(const size_t capacity)
    : _output(capacity)
    , _capacity(capacity)
    , buf(capacity, 0)
    , set(capacity)
    , read_pos(0)
    , _unassembled_bytes(0)
    , eof_index(0) {}

//! \details This function accepts a substring (aka a segment) of bytes,
//! possibly out-of-order, from the logical stream, and assembles any newly
//! contiguous substrings and writes them into the output stream in order.
void StreamReassembler::push_substring(const string &data, const size_t index, const bool eof) {
    size_t start_index = max(index, read_pos);
    size_t end_index = min(index + data.size(), read_pos + _output.remaining_capacity());

    // 先把data暂存到buf中
    for (size_t i = start_index; i < end_index; ++i) {
        size_t real_i = i % _capacity;
        if (set.count(real_i) > 0) {
            continue;
        }
        buf[real_i] = data[i - index];  // 注意这里用i
        set.insert(real_i);
        ++_unassembled_bytes;
    }

    // 能写入_output的部分，最后以write实际返回的为准
    size_t write_end = read_pos;
    while (set.count(write_end % _capacity) > 0 && write_end < read_pos + _capacity) {
        ++write_end;
    }

    if (write_end > read_pos) {
        std::string write_str(write_end - read_pos, 0);
        for (size_t i = read_pos; i < write_end; ++i) {
            write_str[i - read_pos] = buf[i % _capacity];
        }

        size_t n = _output.write(write_str);
        // 写入之后就把set中对应位置清空
        for (size_t i = read_pos; i < read_pos + n; ++i) {
            set.erase(i % _capacity);
        }

        read_pos += n;
        _unassembled_bytes -= n;
    }

    if (eof) {
        eof_index = index + data.size() + 1; // 注意，这里的+1很重要
    }
    if (_output.bytes_written() + 1 == eof_index) { // 和上面的+1对应上
        _output.end_input();
    }
}

size_t StreamReassembler::unassembled_bytes() const { return _unassembled_bytes; }

bool StreamReassembler::empty() const { return unassembled_bytes() == 0; }
