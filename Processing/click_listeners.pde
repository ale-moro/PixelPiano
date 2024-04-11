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