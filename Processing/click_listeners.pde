// Global click listener
void keyPressed() {
  if (activePage.getID() == START_PAGE_INDEX) {  // handles switching from welcome page to play page
    println("Active page index", MODE_SELECTION_PAGE_INDEX);
    navigationController.changePage(activePage, modeSelectionPage);
    println(activePage);
    fill(255, 255);
  }
}

class ButtonClickListener implements ControlListener {
  public void controlEvent(ControlEvent event) {
    println(event);
    println("CLICK: ", event.getName());
    // MODE SELECTION PAGE
    // FreePlayMode listener
    if (event.isController() && event.getName().equals("freePlayButton")) {
      navigationController.changePage(activePage, freePlayPage);
    }
    // PianoHeroMode listener
    else if (event.isController() && event.getName().equals("pianoHeroButton")) {
      navigationController.changePage(activePage, pianoHeroPage);
    }
    
    // PLAY PAGE
    // Back Listener
    if (event.isController() && event.getController().getName().equals("backButton")){
      navigationController.changePage(activePage, modeSelectionPage);
    }
    // OctaveUp listener
    else if (event.isController() && event.getController().getName().equals("octaveUpButton")){
      freePlayPage.octaveUpButtonPressed();
    }
    // OctaveDown listener
    if (event.isController() && event.getController().getName().equals("octaveDownButton")){
      freePlayPage.octaveDownButtonPressed();
    }
    // Mode listener
    if (event.isController() && event.getController().getName().equals("modeButton")){
      freePlayPage.modeButtonPressed();
    }
    // Fader listener
    if (event.isController() && event.getController().getName().equals("mySlider")){
      freePlayPage.faderPressed();
    }
  }
}