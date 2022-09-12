----------------------------------------
----------------------------------------
Logistic: 

$input = 126788567 bytes (uncompressed)
CPU cores = 4
CPU MHz = 2095.079

----------------------------------------
To build Pigzj:
time javac *.java

real    0m1.056s
user    0m1.727s
sys 0m0.129s

Misc.class = 1674 bytes
MultiThreadedGZipCompressor.class = 3568 bytes
Pigzj.class = 1260 bytes
RunnableTask.class = 2105 bytes

Total Memory needed to build Pigzj:
Misc.java = 2629 bytes
MultiThreadedGZipCompressor.java = 3765 bytes
Pigzj.java = 1041 bytes
RunnableTask.java = 1994 bytes

and you will end up with:
Misc.class = 1674 bytes
MultiThreadedGZipCompressor.class = 3568 bytes
Pigzj.class = 1260 bytes
RunnableTask.class = 2105 bytes

----------------------------------------
To build pigzj:
time native-image Pigzj

real    0m40.966s
user    2m15.843s
sys 0m2.419s

Total Memory needed to build pigzj:
Misc.class = 1674 bytes
MultiThreadedGZipCompressor.class = 3568 bytes
Pigzj.class = 1260 bytes
RunnableTask.class = 2105 bytes

and you will end up with:
pigzj = 11704056 bytes

----------------------------------------
----------------------------------------
time gzip <$input >gzip.gz

real    0m7.193s
user    0m7.098s
sys 0m0.064s
Size: 43476941 bytes
Compression Ratio: 2.92

real    0m7.278s
user    0m7.066s
sys 0m0.116s
Size: 43476941 bytes
Compression Ratio: 2.92

real    0m7.283s
user    0m7.066s
sys 0m0.107s
Size: 43476941 bytes
Compression Ratio: 2.92

----------------------------------------
time pigz <$input >pigz.gz

real    0m2.034s
user    0m7.062s
sys 0m0.145s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m2.009s
user    0m6.997s
sys 0m0.131s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m2.159s
user    0m7.028s
sys 0m0.099s
Size: 43351345 bytes
Compression Ratio: 2.92%

----------------------------------------
time pigz -p 1 <$input >pigz.gz

real    0m7.061s
user    0m6.935s
sys 0m0.080s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m7.060s
user    0m6.948s
sys 0m0.065s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m7.428s
user    0m7.299s
sys 0m0.079s
Size: 43351345 bytes
Compression Ratio: 2.92

----------------------------------------
time pigz -p 16 <$input >pigz.gz

real    0m1.977s
user    0m7.028s
sys 0m0.130s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m2.347s
user    0m7.081s
sys 0m0.134s
Size: 43351345 bytes
Compression Ratio: 2.92

real    0m2.027s
user    0m7.104s
sys 0m0.157s
Size: 43351345 bytes
Compression Ratio: 2.92

----------------------------------------
time java Pigzj <$input >Pigzj.gz

real    0m2.764s
user    0m8.263s
sys 0m0.734s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.726s
user    0m8.764s
sys 0m0.570s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.667s
user    0m8.414s
sys 0m0.640s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
time java Pigzj -p 1 <$input >Pigzj.gz

real    0m7.454s
user    0m13.982s
sys 0m0.575s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m7.335s
user    0m14.015s
sys 0m0.548s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m7.388s
user    0m14.111s
sys 0m0.574s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
time java Pigzj -p 16 <$input >Pigzj.gz

real    0m3.131s
user    0m7.607s
sys 0m0.448s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.883s
user    0m7.592s
sys 0m0.476s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.812s
user    0m7.889s
sys 0m0.480s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
time ./pigzj <$input >pigzj.gz

real    0m2.551s
user    0m7.626s
sys 0m0.639s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.809s
user    0m8.317s
sys 0m0.637s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.653s
user    0m8.039s
sys 0m0.698s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
time ./pigzj -p 1 <$input >pigzj.gz

real    0m7.442s
user    0m13.647s
sys 0m0.626s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m7.573s
user    0m13.796s
sys 0m0.728s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m7.555s
user    0m13.731s
sys 0m0.664s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
time ./pigzj -p 16 <$input >pigzj.gz

real    0m2.643s
user    0m7.414s
sys 0m0.548s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m2.834s
user    0m7.428s
sys 0m0.542s
Size: 43352861 bytes
Compression Ratio: 2.92

real    0m3.119s
user    0m7.524s
sys 0m0.583s
Size: 43352861 bytes
Compression Ratio: 2.92

----------------------------------------
----------------------------------------
ls -l gzip.gz pigz.gz Pigzj.gz pigzj.gz

gzip.gz 43476941, Compression Ratio = 2.9162
pigz.gz 43351345, Compression Ratio = 2.9247
pigzj.gz 43352861, Compression Ratio = 2.9246
Pigzj.gz 43352861, Compression Ratio = 2.9246

----------------------------------------
----------------------------------------
Discussion about strace:

strace gzip <$input >gzipstrace
Looking through the strace of gzip, it seems 
that there are quite a lot of read commands.
Probably over 95% of the output of strace is
read commands, however there are a few write
commands as well. 
Example Output:
read(0, "pe\1\0\10<clinit>\1\0\3()V\1\0\nSourceFile"..., 32768) = 32768
read(0, "emCpuTicks\1\0\21ContainerCpuTicks\7\0"..., 32768) = 32768
read(0, "va/lang/Object\1\0\6<init>\1\0\3()V\t\0\10"..., 32768) = 32768
read(0, "\0\0\2\1\340\0\0\0\6\0\1\0\0\0\237\1\341\0\0\0\f\0\1\0\0\0\5\1\342\1\343\0"..., 32768) = 32768
read(0, "\33\0\3\0&\0\243\0`\0D\0\4\0\315\0\n\0a\0b\0\3\0\0\0\330\0W\0X\0"..., 32768) = 32768


strace pigz <$input >pigz.gz
Looking through the strace of pigz, there
are quite a few read commands, but there
are also a lot of futex commands. I couldn't
find any write commands but I'm sure there
may be a few.
Example Output:
read(0, "\352\f\1\353\1\306\1\0\26releasesWithForRemoval\7"..., 131072) = 131072
read(0, "\0\0\0\n\0\350\0\351\0\0\0\1\0\315\0B\0\1\0\336\0\0\0O\0\1\0\1\0\0\0\30"..., 131072) = 131072
read(0, "jdeps/Module;>;\1\0%Lcom/sun/tools"..., 131072) = 131072
futex(0x125c410, FUTEX_WAIT_PRIVATE, 0, NULL) = 0
futex(0x125c3c0, FUTEX_WAKE_PRIVATE, 1) = 0

strace java Pigzj <$input >Pigzj.gz
Looking through the strace of Pigzj, the 
output looks very different from the 
previous two. There are a variety
of commands, unlike pigz and gzip. 
Also, something interesting was this strace
took a much shorter time to run then the 
previous two. 
Example Output:
close(3)                                = 0
openat(AT_FDCWD, "/usr/local/cs/graalvm-ce-java17-22.0.0.2/bin/libjli.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/local/cs/graalvm-ce-java17-22.0.0.2/bin/../lib/libjli.so", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\0\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=73056, ...}) = 0

strace ./pigzj <$input >pigzj.gz
Looking through the strace of pigzj, 
the output consists of almost all 
write commands. This again differs
from the previous 3. 
Example Output:
write(1, "\354\275\7`T\307\265?|\256\332]\255\26\20\2aD\363\32\260\21B]Z5\20\240j\v\323L"..., 37002) = 37002
write(1, "\354}\t|\24E\326\370\253\352\236\364d\322\tCB\200p\310pCN\356#\334G\220+\1\t7"..., 43380) = 43380
write(1, "\354}\t|U\325\361\377\314\315{\271//7\311#\220@H\200\0\1B^\302\276\206E\266\0\201"..., 40111) = 40111
write(1, "\354}\7`U\325\375\377\347\334\373^\356\313\313\ry$\4\0222\10\20 d\1\t2\2\"a\t"..., 34446) = 34446
write(1, "\354\275\7`\24\307\365?\376\231U\331\323i\205\216\23MT\1\22\10\235Do\246\v$@tK\200"..., 38016) = 38016

Comparing all three, they all have quite different output. This is to be 
expected, as all them are quite different programs. Gzip is made of
almost all reads, pigz was made of reads and futexes, Pigzj was a 
wide variety of commands, and pigzj was mostly writes. 

As to if they explain the performance differences, I'm not quite
sure. To be honest, it is quite hard to dissect the strace output
and see why one might be faster or slower than the other. At the end
of the day, gzip was slower due to its lack of multithreading, while 
the others were faster due to their use of multithreading. 

----------------------------------------
----------------------------------------
After-Action Report

How the code works: 
Briefly going over how the code works, there are 4 classes: 
Pigzj is the main class that has the main function in it, 
MultiThreadedGZipCompressor is the class that does the majority of 
the work by creating the threads, creating the tasks, executing
the threads, taking the compressed data and pushing it out to stdout, etc., 
RunnableTask is the class that actually dictates what the threads do,
and Misc is a class with a few miscellaneous functions, variables, and 
constants.

I took a few ideas from MessAdmin code: 
In MessAdmin-Compressor.java, I used the ThreadPoolExecutor idea that 
they had, and used it in my code. Because of this, I used the same idea
of them as creating Runnable tasks, the LinkedBlockingQueue in their
ThreadPoolExecutor, etc. Also, something that isn't necessarily about
the Pigzj program but more about Java in general is the use of try catch
commands. I used Java a bit in high school but never used try catch
commands very often, but I definitely took MessAdmin's coding style 
and tried to apply it more to mine. 

Possible Issues:
One problem that one may run into is increasing the stdin. The way my
implementation works is somewhat memeory inefficient, as I store a bunch
of buffers for runnable tasks, buffers for compressed output, buffers
for uncompressed output, dictionaries, etc. This was the way I made it
to enable multithreading, however it is very memory inefficient because
of this. If stdin is too big, I can very well see how there could be an 
issue of memory running out before the program ends. 

Another possible problem one may run into is increasing the threads
by too much. For some reason, I noticed that when the number of threads 
is close to 4 * the number of available threads, my program runs slightly 
slower than just the default implementation. This may be a hardware 
issue or possibly an issue with my implementation, but either way
I think that increasing the number of threads past the number of available
threads may be a big issue. 

I would like to note that I think the best -p value is the default version,
the max number of available threads. The reason for this is because if 
-p is below the number of available threads, then you are running the 
program slower than you can as you are not using all the threads. If you
have a -p value that is greater than the number of available overheads,
you are increasing the overhead of ThreadPoolExecutor creating more threads 
than can run at a single time, so all you are doing is creating overhead 
without actually running the program any faster. Therefore, the sweet 
medium is simply just the default implementation of the maximum number
of available processors.

Let me also mention the times that I wrote previously in the beginning
of my README. Something that's interesting is the GZIP implementation 
has a real and user time very close to each other. This is understandable
as GZIP uses only one thread, so the user and real time is very similar. 
However, if you notice with the multithreaded implementations, when we
use multiple threads, the real time goes down but the user time stays 
quite high. This is because there are multiple threads working at the 
same time, making the real time go down significantly. However, the 
user time is still high as it is accounting for the threads combined. 
So the combined work is still the same as (basically) a single threaded
implementation. This is why even when we do multithreading, the 
user time is the same as the GZIP implementation real time. Also
this explains why with our multithreaded implementation if you use
-p 1 it will act similarly to the GZIP implementation for both user and
real time. 




