## ffmpeg

软件下载地址: [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)



## 常用命令

分离视频音频流

```
ffmpeg -i input_file -vcodec copy -an output_file_video　　//分离视频流
ffmpeg -i input_file -acodec copy -vn output_file_audio　　//分离音频流
```

视频解复用

```
ffmpeg –i test.mp4 –vcodec copy –an –f m4v test.264
ffmpeg –i test.avi –vcodec copy –an –f m4v test.264
```

视频转码

```
ffmpeg –i test.mp4 –vcodec h264 –s 352*278 –an –f m4v test.264              //转码为码流原始文件
ffmpeg –i test.mp4 –vcodec h264 –bf 0 –g 25 –s 352*278 –an –f m4v test.264  //转码为码流原始文件
ffmpeg –i test.avi -vcodec mpeg4 –vtag xvid –qsame test_xvid.avi            //转码为封装文件
//-bf B帧数目控制，-g 关键帧间隔控制，-s 分辨率控制
```

视频合并

```
ffmpeg –i video_file –i audio_file –vcodec copy –acodec copy output_file
```

视频剪切

```
ffmpeg –i test.avi –r 1 –f image2 image-%3d.jpeg        # 提取图片
ffmpeg -ss 0:1:30 -t 0:0:20 -i input.avi -vcodec copy -acodec copy output.avi    #剪切视频
# -r 提取图像的频率，-ss 开始时间，-t 持续时间
```

视频录制

```
ffmpeg –i rtsp://192.168.3.205:5555/test –vcodec copy out.avi
ffmpeg -i "https://xxxx/index.m3u8" -c copy 1.mp4
```

YUV序列播放

```
ffplay -f rawvideo -video_size 1920x1080 input.yuv
```

YUV序列转AVI

```
ffmpeg –s w*h –pix_fmt yuv420p –i input.yuv –vcodec mpeg4 output.avi
```

## 常用参数说明

```
常用参数说明：
-i 设定输入流
-f 设定输出格式
-ss 开始时间
视频参数：
-b 设定视频流量，默认为200Kbit/s
-r 设定帧速率，默认为25
-s 设定画面的宽与高
-aspect 设定画面的比例
-vn 不处理视频
-vcodec 设定视频编解码器，未设定时则使用与输入流相同的编解码器
音频参数：
-ar 设定采样率
-ac 设定声音的Channel数
-acodec 设定声音编解码器，未设定时则使用与输入流相同的编解码器
-an 不处理音频
```



```
方法一：FFmpeg concat 协议
对于 MPEG 格式的视频，可以直接连接：
ffmpeg -i "concat:input1.mpg|input2.mpg|input3.mpg" -c copy output.mpg
对于非 MPEG 格式容器，但是是 MPEG 编码器（H.264、DivX、XviD、MPEG4、MPEG2、AAC、MP2、MP3 等），可以包装进 TS 格式的容器再合并。在新浪视频，有很多视频使用 H.264 编码器，可以采用这个方法
ffmpeg -i input1.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input1.ts
ffmpeg -i input2.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input2.ts
ffmpeg -i input3.flv -c copy -bsf:v h264_mp4toannexb -f mpegts input3.ts
ffmpeg -i "concat:input1.ts|input2.ts|input3.ts" -c copy -bsf:a aac_adtstoasc -movflags +faststart output.mp4
保存 QuickTime/MP4 格式容器的时候，建议加上  -movflags +faststart。这样分享文件给别人的时候可以边下边看。
方法二：FFmpeg concat 分离器
这种方法成功率很高，也是最好的，但是需要 FFmpeg 1.1 以上版本。先创建一个文本文件 filelist.txt：
file 'input1.mkv'
file 'input2.mkv'
file 'input3.mkv'
然后：
ffmpeg -f concat -i filelist.txt -c copy output.mkv
注意：使用 FFmpeg concat 分离器时，如果文件名有奇怪的字符，要在  filelist.txt 中转义。
方法三：Mencoder 连接文件并重建索引
这种方法只对很少的视频格式生效。幸运的是，新浪视频使用的 FLV 格式是可以这样连接的。对于没有使用 MPEG 编码器的视频（如 FLV1 编码器），可以尝试这种方法，或许能够成功。
mencoder -forceidx -of lavf -oac copy -ovc copy -o output.flv input1.flv input2.flv input3.flv
方法四：使用 FFmpeg concat 过滤器重新编码（有损）
语法有点复杂，但是其实不难。这个方法可以合并不同编码器的视频片段，也可以作为其他方法失效的后备措施。
ffmpeg -i input1.mp4 -i input2.webm -i input3.avi -filter_complex '[0:0] [0:1] [1:0] [1:1] [2:0] [2:1] concat=n=3:v=1:a=1 [v] [a]' -map '[v]' -map '[a]' <编码器选项> output.mkv
如你所见，上面的命令合并了三种不同格式的文件，FFmpeg concat 过滤器会重新编码它们。 注意这是有损压缩。
[0:0] [0:1] [1:0] [1:1] [2:0] [2:1] 分别表示第一个输入文件的视频、音频、第二个输入文件的视频、音频、第三个输入文件的视频、音频。 concat=n=3:v=1:a=1 表示有三个输入文件，输出一条视频流和一条音频流。 [v] [a] 就是得到的视频流和音频流的名字，注意在 bash 等 shell 中需要用引号，防止通配符扩展。
提示
以上三种方法，在可能的情况下，最好使用第二种。第一种次之，第三种更次。第四种是后备方案，尽量避免。
规格不同的视频合并后可能会有无法预测的结果。
有些媒体需要先分离视频和音频，合并完成后再封装回去。
对于 Packed B-Frames 的视频，如果封装成 MKV 格式的时候提示 Can't write packet with unknown timestamp，尝试在 FFmpeg 命令的 ffmpeg 后面加上 -fflags +genpts
```

