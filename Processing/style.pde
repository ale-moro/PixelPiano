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
        button.setColorBackground(color(0));
        button.setColorForeground(color(50));
        button.setVisible(true);
        button.setColorActive(color(50));
        button.getCaptionLabel().setFont(this.customFont);
    }
}