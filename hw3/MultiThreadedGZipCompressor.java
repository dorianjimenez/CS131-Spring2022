import java.io.*;

import java.util.zip.CRC32;

import java.util.concurrent.*;


public class MultiThreadedGZipCompressor {

  private final ThreadPoolExecutor threadPool;
  private final Misc misc;
  private final PushbackInputStream inputStream;
  private final OutputStream outStream;
  private final ByteArrayOutputStream uncompressedOutStream;
  private final int DICT_SIZE;

  private final CRC32 crc = new CRC32();

  private final ConcurrentMap<Integer,byte[]> compressedMap;
  private final ConcurrentMap<Integer,byte[]> dictionaryMap;



  public MultiThreadedGZipCompressor( Misc misc, InputStream inputStream, OutputStream outStream)
  {
    this.outStream = outStream;
    this.inputStream = new PushbackInputStream(inputStream);
    this.misc = misc;

    int numProcessors = misc.getNumProcessors();
    this.DICT_SIZE = Misc.DICT_SIZE;

    this.threadPool = new ThreadPoolExecutor(numProcessors, numProcessors, 1, TimeUnit.SECONDS, new LinkedBlockingQueue<>());
    this.compressedMap = new ConcurrentHashMap<>(numProcessors, 0.75f, numProcessors);
    this.dictionaryMap = new ConcurrentHashMap<>(numProcessors, 0.75f, numProcessors);

    uncompressedOutStream = new ByteArrayOutputStream();
  }


  public void compressInput() {

    try {

      Misc.writeHeader(this.outStream);
      this.crc.reset();

      byte[] blockBuf = new byte[Misc.BLOCK_SIZE];
      byte[] dictBuf;
      int nBytes;
      int totalBytesRead = 0;
      int count = 0;

      boolean hasDict = false;
      boolean eof;

      boolean noInput = false;
      if(!Misc.checkInputBytesLeft(inputStream)) {
        noInput = true;
        Misc.setCompressionCheck();
      }

      while (((nBytes = inputStream.read(blockBuf, totalBytesRead, Misc.BLOCK_SIZE - totalBytesRead)) >= 0)) {

        totalBytesRead += nBytes;
        if ((totalBytesRead < Misc.BLOCK_SIZE) && (Misc.checkInputBytesLeft(inputStream))) {
          continue;
        }
        nBytes = totalBytesRead;
        totalBytesRead = 0;

        uncompressedOutStream.write(blockBuf, 0, nBytes);

        eof = !Misc.checkInputBytesLeft(inputStream);

        byte[] readBytes = new byte[nBytes];
        System.arraycopy(blockBuf, 0, readBytes, 0, nBytes);


        threadPool.execute(new RunnableTask(
                this.compressedMap,
                this.dictionaryMap,
                count,
                readBytes,
                nBytes,
                hasDict,
                eof));

        if (nBytes == Misc.BLOCK_SIZE && !eof) {
          dictBuf = new byte[this.DICT_SIZE];
          System.arraycopy(blockBuf, Misc.BLOCK_SIZE - this.DICT_SIZE, dictBuf, 0, this.DICT_SIZE);
          dictionaryMap.put(count, dictBuf);
        }

        hasDict = true;

        count++;
      }

      //---------------------------------

      int index = 0;

      while (((!Misc.getCompressionCheck()) || (threadPool.getActiveCount() > 0) || (compressedMap.size() > 0))) {
        if (compressedMap.containsKey(index))
        {
          byte[] comp_bytes = compressedMap.get(index);

          outStream.write(comp_bytes);
          compressedMap.remove(index);

          index++;
        }
      }


      threadPool.shutdown();

      byte[] totalBytes = uncompressedOutStream.toByteArray();
      crc.update(totalBytes);


      //Trailer
      if (noInput)
      {
        byte[] noneTrailer = {3, 0};
        outStream.write(noneTrailer, 0, 2);
      }
      
      byte[] trailerBuf = new byte[Misc.TRAILER_SIZE];
      misc.writeTrailer(totalBytes.length, trailerBuf, 0, crc);
      try {
        outStream.write(trailerBuf);
      }
      catch (Throwable e) {
        e.printStackTrace();
        System.exit(1);
      }



    } catch (Throwable e)
    {
      e.printStackTrace();
      System.exit(1);
    }
  }
}
