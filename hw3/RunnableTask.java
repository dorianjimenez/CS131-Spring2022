import java.io.*;

import java.util.zip.Deflater;

import java.util.concurrent.*;


public class RunnableTask implements Runnable {

  private final ConcurrentMap<Integer,byte[]> compressedMap;
  private final ConcurrentMap<Integer,byte[]> dictionaryMap;
  private final int count;
  private final byte[] readBytes;
  private final int nBytes;
  private final boolean hasDict;
  private final boolean eof;

  private final Deflater compressor;
  private final ByteArrayOutputStream compressedOutStream;
  private final byte[] cmpBlockBuf;

  public RunnableTask(ConcurrentMap<Integer,byte[]> compressedMap, ConcurrentMap<Integer,byte[]> dictionaryMap,
                      int count, byte[] readBytes, int nBytes, boolean hasDict, boolean eof) {

    this.compressedMap = compressedMap;
    this.dictionaryMap = dictionaryMap;
    this.count = count;
    this.readBytes = readBytes;
    this.nBytes = nBytes;
    this.hasDict = hasDict;
    this.eof = eof;

    compressor = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
    compressedOutStream = new ByteArrayOutputStream();
    cmpBlockBuf = new byte[Misc.BLOCK_SIZE * 2];
  }

  public void run() {
    try {
      int deflatedBytes = 0;


      if (hasDict) {
        compressor.setDictionary(dictionaryMap.get(count - 1));
      }

      compressor.setInput(readBytes, 0, nBytes);

      if (!eof) {
        deflatedBytes = compressor.deflate(cmpBlockBuf, 0, cmpBlockBuf.length, Deflater.SYNC_FLUSH);
      }
      else {
        compressor.finish();
        while (!compressor.finished()) {
          deflatedBytes = compressor.deflate(cmpBlockBuf, 0, cmpBlockBuf.length, Deflater.NO_FLUSH);
        }
      }
      compressedOutStream.write(cmpBlockBuf, 0, deflatedBytes);

      compressedMap.put(count, compressedOutStream.toByteArray());

      compressedOutStream.reset();

      if(eof) {
        Misc.setCompressionCheck();
      }
    }
    catch (Throwable e) {
      e.printStackTrace();
      System.exit(1);
    }
  }

}
