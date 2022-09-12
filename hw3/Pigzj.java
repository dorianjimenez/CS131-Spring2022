public class Pigzj {
  public static void main(String[] args) {

    int processCount = 1;
    if (args.length == 0) {
      processCount = Runtime.getRuntime().availableProcessors();
    }
    else if(args[0].equals("-p") && (args.length == 2)) {
      try {
        processCount = Integer.parseInt(args[1]);
      }
      catch (NumberFormatException x) {
        System.err.println("Incorrect arguments");
        System.exit(1);
      }
      if(processCount <= 0)
      {
        System.err.println("Incorrect arguments");
        System.exit(1);
      }
      if(processCount > (4 *  Runtime.getRuntime().availableProcessors()))
      {
        System.err.println("More than 4 Times Available processors");
        System.exit(1);
      }
    }
    else {
      System.err.println("Incorrect arguments");
      System.exit(1);
    }

    Misc misc = new Misc();
    misc.setNumProcessors(processCount);

    MultiThreadedGZipCompressor cmp = new MultiThreadedGZipCompressor(misc, System.in, System.out);
    cmp.compressInput();
  }

}