import java.io.*;

import java.util.zip.Deflater;
import java.util.zip.CRC32;

public class Misc {
    
    public final static int GZIP_MAGIC = 0x8b1f;
    public final static int TRAILER_SIZE = 8;
    public static final int BLOCK_SIZE = 131072;
    public static final int DICT_SIZE = 32768;


    private volatile int numProcessors;

    private static boolean checkCompression = false;

    public void setNumProcessors(int numProcessors) {
        this.numProcessors = numProcessors;
    }

    public int getNumProcessors() {
        return this.numProcessors;
    }

    public static boolean getCompressionCheck() {return checkCompression; }

    public static void setCompressionCheck() { checkCompression = true;}


    public static boolean checkInputBytesLeft(PushbackInputStream inputStream)
    {
        try {
            int bytes = inputStream.read();

            if (bytes >= 0) {
                inputStream.unread(bytes);
                return true;
            }
            else {
                return false;
            }
        }
        catch (Throwable e) {
            return false;
        }
    }


    // ------------------------------- Header and Trailer ------------------------------------

    public static void writeHeader(OutputStream outputStream) throws IOException {
        outputStream.write(new byte[] {
                (byte) GZIP_MAGIC,       // Magic number (short)
                (byte)(GZIP_MAGIC >> 8), // Magic number (short)
                Deflater.DEFLATED,       // Compression method (CM)
                0,                       // Flags (FLG)
                0,                       // Modification time MTIME (int)
                0,                       // Modification time MTIME (int)
                0,                       // Modification time MTIME (int)
                0,                       // Modification time MTIME (int)
                0,                       // Extra flags
                0                        // Operating system (OS)
        });
    }

    public void writeTrailer(long totalBytes, byte[] buf, int offset, CRC32 crc) {
        writeInt((int)crc.getValue(), buf, offset); // CRC-32 of uncompressed data
        writeInt((int)totalBytes, buf, offset + 4); // Number of uncompressed bytes
    }

    private void writeInt(int i, byte[] buf, int offset) {
        writeShort(i & 0xffff, buf, offset);
        writeShort((i >> 16) & 0xffff, buf, offset + 2);
    }

    private void writeShort(int s, byte[] buf, int offset) {
        buf[offset] = (byte)(s & 0xff);
        buf[offset + 1] = (byte)((s >> 8) & 0xff);
    }
}
