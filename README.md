# lab1

https://cs144.github.io/

这次实验是完成一个能重组Steam的类，因为TCP有各种重试机制，可能会重复、重叠、乱序等情况，为了应对这些情况来实现这样一个类。

下图就是整体流程：



这次代码需要写的不多，但是lab1任务书里有些地方可能要完全理解才能写下去，有些东西还没讲qwq，要靠自己跑测试case才能发现问题。


然后我也画了一个和任务书里类似的图，理解它也很重要：



大体流程如下：
1. 接收`data`，写入`buf`和记录`set`，有重复的就可以不用在记了。
2. 把现在已经重组好的`wirte`进`_output`里
3. 判断eof

流程看起来不复杂，但是要通过每一个测试case还是要下一定功夫的。


话不多说，直接看代码：
```cpp
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
```

下面记录了一些坑：
- `index`和`read_pos`都是会一直递增的，当要操作`buf`或者`set`时，需要用`_capacity`取模一下。
- 最后面eof的判断有点坑，一般来说我们只要`index+data.size()`即可表示eof的位置，
但是有一种情况这种时过不了的，就是当写入为空时，可以自行尝试。
- `set`用来记录当前`buf`里哪些已经收到了，也可以用`vector<size_t>`，效果都一样。


最后跑测试case：
```sh
$ make check_lab1
[100%] Testing the stream reassembler...
Test project /media/sf_share/sponge/build
      Start 15: t_strm_reassem_single
 1/16 Test #15: t_strm_reassem_single ............   Passed    0.00 sec
      Start 16: t_strm_reassem_seq
 2/16 Test #16: t_strm_reassem_seq ...............   Passed    0.00 sec
      Start 17: t_strm_reassem_dup
 3/16 Test #17: t_strm_reassem_dup ...............   Passed    0.01 sec
      Start 18: t_strm_reassem_holes
 4/16 Test #18: t_strm_reassem_holes .............   Passed    0.01 sec
      Start 19: t_strm_reassem_many
 5/16 Test #19: t_strm_reassem_many ..............   Passed    0.50 sec
      Start 20: t_strm_reassem_overlapping
 6/16 Test #20: t_strm_reassem_overlapping .......   Passed    0.00 sec
      Start 21: t_strm_reassem_win
 7/16 Test #21: t_strm_reassem_win ...............   Passed    0.53 sec
      Start 22: t_strm_reassem_cap
 8/16 Test #22: t_strm_reassem_cap ...............   Passed    0.08 sec
      Start 23: t_byte_stream_construction
 9/16 Test #23: t_byte_stream_construction .......   Passed    0.00 sec
      Start 24: t_byte_stream_one_write
10/16 Test #24: t_byte_stream_one_write ..........   Passed    0.00 sec
      Start 25: t_byte_stream_two_writes
11/16 Test #25: t_byte_stream_two_writes .........   Passed    0.00 sec
      Start 26: t_byte_stream_capacity
12/16 Test #26: t_byte_stream_capacity ...........   Passed    0.34 sec
      Start 27: t_byte_stream_many_writes
13/16 Test #27: t_byte_stream_many_writes ........   Passed    0.01 sec
      Start 50: t_address_dt
14/16 Test #50: t_address_dt .....................   Passed    0.05 sec
      Start 51: t_parser_dt
15/16 Test #51: t_parser_dt ......................   Passed    0.00 sec
      Start 52: t_socket_dt
16/16 Test #52: t_socket_dt ......................   Passed    0.01 sec

100% tests passed, 0 tests failed out of 16

Total Test time (real) =   1.64 sec
[100%] Built target check_lab1
```

OK，准备整lab2!