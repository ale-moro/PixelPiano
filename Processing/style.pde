class StyleManager {

    float[] inactivePosition;
    PFont customFont;

    public StyleManager(){
        this.customFont = createFont("Arial", 20);
        this.inactivePosition = new float[] {-1000, -1000};
        this.customFont = createFont("Monospaced", 20);
    }

    public void setDefaultButtonStyle(Button button){
        button.setPosition(this.inactivePosition);
        button.setColorForeground(color(200))
        button.setColorBackground(color(0,0,0,1))
        button.setVisible(true);
        button.setColorActive(color(50));
        button.getCaptionLabel().setFont(this.customFont);
    }

    public void drawButtonBox(Button b, float radius){
        fill(0);
        stroke(0);
        rect(b.getPosition()[0]-5, b.getPosition()[1]-5, b.getWidth()+10, b.getHeight()+10, radius);

        fill(0, 200);
        rect(b.getPosition()[0], b.getPosition()[1], b.getWidth()+10, b.getHeight()+10, radius); 
    }

    public void drawVerticalSliderBox(Slider s, float radius){
        stroke(0);
        fill(0);
        rect(s.getPosition()[0]-5, s.getPosition()[1]-10, s.getWidth()+35, s.getHeight()+20, radius);
        fill(0, 200);
        
        rect(s.getPosition()[0], s.getPosition()[1]-5, s.getWidth()+35, s.getHeight()+20, radius); 
    }

    public void drawDropdownBox(DropdownList d, float radius){
        stroke(0);
        fill(0);
        rect(d.getPosition()[0]-5, d.getPosition()[1]-5, d.getWidth()+10, d.getHeight()+10, radius);
        fill(0, 200);
        rect(d.getPosition()[0], d.getPosition()[1], d.getWidth()+10, d.getHeight()+10, radius);
    }
}