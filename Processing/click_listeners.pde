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
 
      float curr_x = coords[i] * width;
      float curr_y = coords[i+1] * height;
      if(x_ur > curr_x && curr_x> x_ul && y_dl > curr_y && curr_y > y_ul && pressed[floor(i/2)] == 1){
        //println(button.getName());
        Tab controller = new Tab(cp5, cp5.controlWindow, button.getName());
        ControlEvent event = new ControlEvent(controller);
        activePage.handleButtonClick(event); 
      
      }
      i++;
    }
      
      
}

public void checkFader(float[] coords, Slider fader, int[] pressed){
  float fader_width = fader.getWidth();
  float fader_height = fader.getHeight();
  float x_up_l = fader.getPosition()[0];
  float y_up_l = fader.getPosition()[1];
  float x_up_r = x_up_l + fader_width;
  float y_down_l = y_up_l + fader_height;
  
  for(int i= 0; i < coords.length; i++){
      float curr_x = coords[i] * width;
      float curr_y = coords[i+1] * height;
      if(x_up_r > curr_x && curr_x> x_up_l && y_down_l > curr_y && curr_y > y_up_l && pressed[floor(i/2)] == 1){
        float elementPosition = map(curr_y, y_down_l, y_up_l, 0, 100);
        fader.setValue(elementPosition);
        msgClass.sendVolumeMsg(100 - elementPosition);
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
