#include "byte_stream.hh"

// Dummy implementation of a flow-controlled in-memory byte stream.

// For Lab 0, please replace with a real implementation that passes the
// automated checks run by `make check_lab0`.

// You will need to add private members to the class declaration in `byte_stream.hh`

template <typename... Targs>
void DUMMY_CODE(Targs &&... /* unused */) {}

using namespace std;

ByteStream::ByteStream(const size_t capacity)
    : buf(capacity, 0), cap(capacity), used(0), read_pos(0), _end_input(false) {}

size_t ByteStream::write(const string &data) {
    // 没有空间写入
    if (remaining_capacity() == 0) {
        return 0;
    }

    size_t size = min(data.size(), remaining_capacity());  // 实际写入的大小
    size_t start = (read_pos + used) % cap;                // 写入的起点
    size_t end = (start + size) % cap;                     // 写入的终点
    used += size;
    if (end > start) {
        buf.replace(buf.begin() + start, buf.begin() + end, data.begin(), data.begin() + size);
    } else {
        buf.replace(buf.begin() + start, buf.begin() + cap, data.begin(), data.begin() + (cap - start));
        buf.replace(buf.begin(), buf.begin() + end, data.begin() + (cap - start), data.begin() + size);
    }

    return size;
}

//! \param[in] len bytes will be copied from the output side of the buffer
string ByteStream::peek_output(const size_t len) const {
    size_t size = min(len, used);

    string ret;
    ret.reserve(size);
    if ((read_pos % cap) + size <= cap) {
        ret.append(buf.begin() + (read_pos % cap), buf.begin() + (read_pos % cap) + size);
    } else {
        ret.append(buf.begin() + (read_pos % cap), buf.begin() + cap);
        ret.append(buf.begin(), buf.begin() + (size - (cap - (read_pos % cap))));
    }

    return ret;
}

//! \param[in] len bytes will be removed from the output side of the buffer
void ByteStream::pop_output(const size_t len) {
    size_t size = min(used, len);
    used -= size;
    read_pos += size;
}

//! Read (i.e., copy and then pop) the next "len" bytes of the stream
//! \param[in] len bytes will be popped and returned
//! \returns a string
std::string ByteStream::read(const size_t len) {
    string ret = peek_output(len);
    pop_output(len);
    return ret;
}

void ByteStream::end_input() { _end_input = true; }

bool ByteStream::input_ended() const { return _end_input; }

size_t ByteStream::buffer_size() const { return used; }

bool ByteStream::buffer_empty() const { return used == 0; }

bool ByteStream::eof() const { return input_ended() && buffer_empty(); }

size_t ByteStream::bytes_written() const { return read_pos + used; }

size_t ByteStream::bytes_read() const { return read_pos; }

size_t ByteStream::remaining_capacity() const { return cap - used; }
