import controlP5.*;
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
    float button_width = button.getWidth();
    float button_height = button.getHeight();  
    float x_ul = button.getPosition()[0];
    float y_ul = button.getPosition()[1];
    float x_ur = x_ul + button_width;
    float y_dl = y_ul + button_height;

  
    for(int i = 0; i < coords.length; i++){
      for(int j = 0; j < 5; j++){
        float curr_x = coords[i] * width;
        float curr_y = coords[i+1] * height;
        if(x_ur > curr_x && curr_x> x_ul && y_dl > curr_y && curr_y > y_ul && pressed[j] == 1){
          //println(button.getName());
          Tab controller = new Tab(cp5, cp5.controlWindow, button.getName());
          ControlEvent event = new ControlEvent(controller);
          activePage.handleButtonClick(event); 
        }
      }
      i++;
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
