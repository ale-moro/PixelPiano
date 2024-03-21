public interface Page {

    public int getID();

    public void draw();

    public void addListeners();
    public void removeListeners();

    public void setVisibility(boolean isVisible);

    public void handleButtonClick(ControlEvent event);
}