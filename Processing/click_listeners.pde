// Global click listener
void keyPressed() {
  if (activePage.getID() == START_PAGE_INDEX) {  // handles switching from welcome page to play page
    println("Active page index", MODE_SELECTION_PAGE_INDEX);
    navigationController.changePage(activePage, modeSelectionPage);
    println(activePage);
    fill(255, 255);
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