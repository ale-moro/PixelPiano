import java.nio.file.Paths;
import java.nio.file.Path;

static class Utils {
    
  public static String getOperatingSystem() {
      String os = System.getProperty("os.name");
      // System.out.println("Using System Property: " + os);
      return os;
  }

  public static boolean isWindows(){
       return getOperatingSystem().toLowerCase().contains("windows");      
  }
  
  public static String safePath(String s) {
    // windows
    if(isWindows()){
      return s.replace('/', '\\');
    } else {
      return s.replace('\\', '/');
    }
  }

  public static String getFileNameFromPath(String path){
    String filename = path.replace("/", "\\");
    filename = filename.substring(filename.lastIndexOf("\\") + 1);
    filename = filename.substring(0, min(23, filename.length()));
    return filename;
  }

  public static boolean isAbsolutePath(String path){
    Path p = Paths.get(path); 
    return p.isAbsolute();
  }
}
