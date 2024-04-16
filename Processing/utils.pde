static class Utils{
    
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
}
