import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

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

public static class PathUtils {
    
    public static ArrayList<String> getFileNamesInFolder(String folderPath) {
        ArrayList<String> fileNames = new ArrayList<>();
        java.io.File folder = new java.io.File(folderPath);
        
        if (folder.exists() && folder.isDirectory()) {
            java.io.File[] files = folder.listFiles();
            if (files != null) {
                for (java.io.File file : files) {
                    if (file.isFile()) {
                        fileNames.add(file.getName());
                    }
                }
            }
        }
        
        return fileNames;
    }
}
