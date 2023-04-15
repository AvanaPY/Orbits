public class UI
{
  private UIElement[] elements;

  private SelectedPlanetInfoWindow planetInfoWindow;
  private UIPlanetListWindow planetListWindow;
  private UIKeybindWindow kbWindow;
  public UI()
  {
    planetListWindow = new UIPlanetListWindow(width - 200, 0, 200, 300, false);
    planetInfoWindow = new SelectedPlanetInfoWindow(new PVector(width - 200, 300), new PVector(200, 0), true);
    kbWindow = new UIKeybindWindow(0, height - 240, 150, 240);

    elements = new UIElement[] {
      planetInfoWindow,
      planetListWindow,
      kbWindow
    };
  }

  public void toggle()
  {
    for (UIElement element : elements)
      element.toggle();
  }

  public void render()
  {
    if (PlanetSelector.getCurrentlySelectedPlanet() != null)
      planetInfoWindow.render();
    planetListWindow.render();
    kbWindow.render();

    fill(0, 0, 360);
    noStroke();
    textAlign(LEFT, TOP);
    text("Mode: " + OnMouseClickModeEnumManager.getCurrentOnMouseClickModeEnum(), 5, 5);
    text("Framerate: " + round(frameRate), 5, 20);
  }

  public boolean positionInUI(float x, float y)
  {
    for (UIElement element : elements)
      if (element.positionInElement(x, y))
        return true;
    return false;
  }

  public boolean click(float x, float y)
  {
    for (UIElement element : elements)
      if (element.click(x, y))
        return true;
    return false;
  }

  public boolean mouseDragged(float x, float y)
  {
    if (positionInUI(x, y))
      return true;
    return false;
  }
}
