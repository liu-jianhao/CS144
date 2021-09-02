# CS144
我的CS144课程学习记录及解决

https://cs144.github.io/

## lab0
[lab0指导](chrome-extension://cdonnmffkdaoajfknoeeecmchibpmkmg/assets/pdf/web/viewer.html?file=https%3A%2F%2Fcs144.github.io%2Fassignments%2Flab0.pdf)

这个实验是一个热身实验，主要工作是搭建好环境和完成两个小编程作业。

### 0.搭建环境
指导里推荐是使用virtualbox和它提供的镜像，只需要下好镜像即可。
https://stanford.edu/class/cs144/vm_howto/vm-howto-image.html

下好之后，用virtualbox打开需要重置密码，然后可以用本机ssh连接上虚拟机：
```sh
ssh -p 2222 cs144@localhost
```
然后可以设置好一个共享文件夹，这样方便我们在本机的IDE编写代码，然后在虚拟机里编译运行代码。

接着就是拉取代码，然后编译一下。

也可以跟着指导里的操作试一试。
### 1.webget
简单来说就是用TCP发送HTTP格式的请求。

需要用上`TCPSocket`和`Address`这两个类的实现。（要先看看这两个类的实现）
- TCPSocket其实就是TCP socket的一个包装，我们可以使用它来连接一个Address。
- Address就是一个网络地址。

知道这些后完成webget就很简单了：
```cpp
    TCPSocket socket;
    Address addr(host, "http");
    socket.connect(addr);
    socket.write("GET " + path + " HTTP/1.1\r\n"
                 + "Host: " + host + "\r\n"
                 + "Connection: close\r\n\r\n");

    while (!socket.eof()) {
        cout << socket.read();
    }
```

测试：
```sh
$ make check_webget
[100%] Testing webget...
Test project /media/sf_share/sponge/build
    Start 28: t_webget
1/1 Test #28: t_webget .........................   Passed    6.56 sec

100% tests passed, 0 tests failed out of 1

Total Test time (real) =   6.58 sec
[100%] Built target check_webget
```

OK，第一场热身完成。

### 2.byte stream
这个作业是需要完成一个字节流，它是一个大小固定的内存。

大致的结构如下图：

只要能理解上面的图，实现起来基本就不难了。

- 需要注意的是，读写操作是一个“环形”操作，比如write到了数组末尾，假如数组开头已经被读取了，说明还有位置可以写入。
- 字符串截取最好用iterator，不要用下标截取，iterator是左闭右开，下标是左闭右闭，需要注意这一点。

具体的代码实现可以看代码这里就贴出来了。

测试：
```sh
$ make check_lab0
[100%] Testing Lab 0...
Test project /media/sf_share/sponge/build
    Start 23: t_byte_stream_construction
1/9 Test #23: t_byte_stream_construction .......   Passed    0.01 sec
    Start 24: t_byte_stream_one_write
2/9 Test #24: t_byte_stream_one_write ..........   Passed    0.01 sec
    Start 25: t_byte_stream_two_writes
3/9 Test #25: t_byte_stream_two_writes .........   Passed    0.01 sec
    Start 26: t_byte_stream_capacity
4/9 Test #26: t_byte_stream_capacity ...........   Passed    0.45 sec
    Start 27: t_byte_stream_many_writes
5/9 Test #27: t_byte_stream_many_writes ........   Passed    0.01 sec
    Start 28: t_webget
6/9 Test #28: t_webget .........................   Passed    1.65 sec
    Start 50: t_address_dt
7/9 Test #50: t_address_dt .....................   Passed    0.09 sec
    Start 51: t_parser_dt
8/9 Test #51: t_parser_dt ......................   Passed    0.00 sec
    Start 52: t_socket_dt
9/9 Test #52: t_socket_dt ......................   Passed    0.01 sec

100% tests passed, 0 tests failed out of 9

Total Test time (real) =   2.30 sec
[100%] Built target check_lab0
```

第二场热身完成！