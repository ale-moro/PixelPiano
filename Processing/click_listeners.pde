// Global click listener
void keyPressed() {
  if (activePage.getID() == START_PAGE_INDEX) {  // handles switching from welcome page to play page
    navigationController.changePage(activePage, modeSelectionPage);
  }
}

public class ButtonClickListener implements ControlListener {
    
    private final Page page;
    
    public ButtonClickListener(Page page) {
      this.page = page;
    }

    @Override
    public void controlEvent(ControlEvent event) {
      println(event);
      println("CLICK: ", event.getName());
      if (event.isGroup()) {
          println("group CLICK: ", event.getGroup().getValue());
      }
      
      this.page.handleButtonClick(event);
    }
    
}

public void checkCoordinates(float[] coords, Button button, int[] pressed){
    float x_ul = button.getX();
    float y_ul = button.getY();
    float button_width = button.getWidth();
    float button_height = button.getHeight();
    float x_ur = x_ul + button_width;
    float y_dl = y_ul + button_height;

    
    for(int i = 0; i < coords.length; i++){
      if(x_ur > coords[i] > x_ul && y_dl > coords[i+1] > y_ul && pressed[i] == 1 ){
        print("giusto");
      }
    }
      
      
}

public class GroupControlListener implements ControlListener {
    
    private final Page page;
    
    public GroupControlListener(Page page) {
      this.page = page;
    }

    @Override
    public void controlEvent(ControlEvent event) {
      println(event);
      println("CLICK: ", event.getName());
      
      this.page.handleButtonClick(event);
    }
}
