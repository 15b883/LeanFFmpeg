#!/bin/bash
#
src_dir='/data/mp4'

#mp4-->ts
zhuanma_1='-r 25 -s 1920*1080 -aspect 16:9 -vcodec libx264  -strict -2 -acodec libfaac -c copy -vbsf h264_mp4toannexb'

#ts--m3u8
#ts_m3u8='-c copy -map 0 -f segment -segment_list playlist.m3u8 -segment_time 10'

select_file(){
	for i in `ls ${src_dir}`;do
	  ret_1=`echo $i|awk -F . '{print $1}'|cut -d '_' -f 4`	  
	  ret_2=`echo $i|awk -F . '{print $1}'|cut -d '_' -f 3`	  
	  ret_3=`echo $i|awk -F . '{print $1}'|cut -d '_' -f 2`	  
          ret_4=`echo $i|awk -F . '{print $1}'|awk -F _ '{print $1}'`
          ret_5=`echo $i|awk -F . '{print $1}'`
          show_dx=`ffprobe -show_streams ${src_dir}/${i} >${src_dir}/${ret_5}.txt` 
          echo ${show_dx}
#          numb_1=`cat ${show_dx}|grep -w 'Stream #0:0'|awk -F '[ ,]' '{print $22}'`
          numb_1=`cat ${src_dir}/${ret_5}.txt|awk 'NR==34{print}'|awk -F = '{print $2}'`
          echo ${numb_1}
          numb_2=`echo $numb_1*0.0006|bc`
          numb_3=`echo $numb_1*0.0008|bc`
          echo ${numb_2}
#          num_a=`awk -F . '{print $1}' "${numb_2}"`
          malv_1="-b:v ${numb_2}"
          malv_2="-b:v ${numb_3}"
#          malv_2="-b:v `${num_b}`"
          echo ${malv_1}
#          echo ${malv_2}
#          zhuanma_1="-r 25 -s 1920*1080 ${malv_1} -aspect 16:9 -vcodec h264  -strict -2 -acodec aac -c copy -bsf h264_mp4toannexb"
#          zhuanma_2="-r 25 -s 1920*1080 ${malv_2} -aspect 16:9 -vcodec h264  -strict -2 -acodec aac -c copy -bsf h264_mp4toannexb"
#          ts_m3u8='-c copy -map 0 -f segment -segment_list playlist.m3u8 -segment_time 10'


          rm -rf ${src_dir}/${ret_5}.txt
           
	  if [ $ret_1 == 1 ] || [ $ret_1 == 2 ];then
	    if [ -d /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5} ];then
	      echo "exists"
	      ffmpeg -i ${src_dir}/${ret_4}_${ret_3}_${ret_2}_${ret_1}.mp4 ${zhuanma_1} ${malv_1} /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts
              ffmpeg -i /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts -c copy -map 0 -f segment -segment_list /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/playlist.m3u8 -segment_time 10  /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}%03d.ts
	    else
	      mkdir -p /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}
	      ffmpeg -i ${src_dir}/${ret_4}_${ret_3}_${ret_2}_${ret_1}.mp4 ${zhuanma_1} ${malv_1} /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts
              ffmpeg -i /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts -c copy -map 0 -f segment -segment_list /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/playlist.m3u8 -segment_time 10  /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}%03d.ts
#              ffmpeg -i /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts ${ts_m3u8} /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}%03d.ts
	    fi
	  else
	    echo "error"
	  fi
          if [ $ret_1 == 3 ];then
            if [ -d /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5} ];then
              echo "exists"
              ffmpeg -i ${src_dir}/${ret_4}_${ret_3}_${ret_2}_${ret_1}.mp4 ${zhuanma_1} ${malv_2} /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts
              ffmpeg -i /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts -c copy -map 0 -f segment -segment_list /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/playlist.m3u8 -segment_time 10  /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}%03d.ts
            else
              mkdir -p /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}
              ffmpeg -i ${src_dir}/${ret_4}_${ret_3}_${ret_2}_${ret_1}.mp4 ${zhuanma_1} ${malv_2} /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts
              ffmpeg -i /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}.ts -c copy -map 0 -f segment -segment_list /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/playlist.m3u8 -segment_time 10  /data/ziyuan/${ret_1}/${ret_2}/${ret_3}/${ret_5}/${ret_5}%03d.ts
            fi
          else
            echo "error"
          fi
	done


}
select_file
