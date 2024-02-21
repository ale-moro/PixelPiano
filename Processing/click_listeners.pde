// Global click listener
void keyPressed() {
  if (!isPlaying) {  // handles switching from welcome page to play page
      println("Play pressed. Start playing.");
      isPlaying = true;
      background(0, 0);   
    }
}

class ButtonClickListener implements ControlListener {
  public void controlEvent(ControlEvent event) {
    
    // Back Listener
    if (event.isController() && event.getController().getName().equals("back") && event.getId()==-1){
      isPlaying = false;
      playPage.backButtonPressed();
    }
    
    // OctaveUp listener
    if (event.isController() && event.getController().getName().equals("octaveUp")){
      playPage.octaveUpButtonPressed();
    }
    
    // OctaveDown listener
    if (event.isController() && event.getController().getName().equals("octaveDown")){
      playPage.octaveDownButtonPressed();
    }
    
    // Mode listener
    if (event.isController() && event.getController().getName().equals("mode")){
      playPage.modeButtonPressed();
    }
    
    // Fader listener
    if (event.isController() && event.getController().getName().equals("mySlider")){
      playPage.faderPressed();
    }
  }
}