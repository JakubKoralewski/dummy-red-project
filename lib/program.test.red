Red []
#include %./program.red

parse-result: parse-ffmpeg-version "ffmpeg version 4.1.3 Copyright (c) 2000-2019 the FFmpeg developers^/built with gcc 8.3.1 (GCC) 20190414"
either parse-result <> "4.1.3" [
    ?? parse-result
    throw rejoin ["Error " dbl-quote parse-result dbl-quote]
] [
    print "Passed"
]

parse-result: parse-ffmpeg-version "ffmpeg version git-2020-04-22-2e38c63 Copyright (c) 2000-2020 the FFmpeg developers built with gcc 9.3.1 (GCC) 20200328 configuration: --enable-gpl --enable-version3 --enable-sdl2 --enable-fontconfig --enable-gnutls --enable-iconv --enable-libass --enable-libdav1d --enable-libbluray --enable-libfreetype --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libopus --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libsrt --enable-libtheora --enable-libtwolame --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libzimg --enable-lzma --enable-zlib --enable-gmp --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvo-amrwbenc --enable-libmysofa --enable-libspeex --enable-libxvid --enable-libaom --disable-w32threads --enable-libmfx --enable-ffnvcodec --enable-cuda-llvm --enable-cuvid --enable-d3d11va --enable-nvenc --enable-nvdec --enable-dxva2 --enable-avisynth --enable-libopenmpt --enable-amf libavutil      56. 42.102 / 56. 42.102 libavcodec     58. 80.100 / 58. 80.100 libavformat    58. 42.101 / 58. 42.101 libavdevice    58.  9.103 / 58.  9.103 libavfilter     7. 79.100 /  7. 79.100 libswscale      5.  6.101 /  5.  6.101 libswresample   3.  6.100 /  3.  6.100 libpostproc    55.  6.100 / 55.  6.100"
either parse-result <> "git-2020-04-22-2e38c63" [
    throw rejoin ["Error " ?? parse-result]
] [
    print "Passed"
]