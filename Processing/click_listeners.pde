// Global click listener
void keyPressed() {
  if (activePage.getID() == START_PAGE_INDEX) {  // handles switching from welcome page to play page
    println("Active page index", MODE_SELECTION_PAGE_INDEX);
    navigationController.changePage(startPage, modeSelectionPage);
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
    if (event.isController() && event.getName().equals("freePlay")) {
      navigationController.changePage(modeSelectionPage, freePlayPage);
    }
    // PianoHeroMode listener
    else if (event.isController() && event.getName().equals("pianoHero")) {
      navigationController.changePage(modeSelectionPage, pianoHeroPage);
    }
    
    // PLAY PAGE
    // Back Listener
    if (event.isController() && event.getController().getName().equals("back")){
      navigationController.changePage(freePlayPage, modeSelectionPage);
    }
    // OctaveUp listener
    else if (event.isController() && event.getController().getName().equals("octaveUp")){
      freePlayPage.octaveUpButtonPressed();
    }
    // OctaveDown listener
    if (event.isController() && event.getController().getName().equals("octaveDown")){
      freePlayPage.octaveDownButtonPressed();
    }
    // Mode listener
    if (event.isController() && event.getController().getName().equals("mode")){
      freePlayPage.modeButtonPressed();
    }
    // Fader listener
    if (event.isController() && event.getController().getName().equals("mySlider")){
      freePlayPage.faderPressed();
    }
  }
}