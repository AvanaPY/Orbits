public class UI
{
  private UIElement[] elements;

  private SelectedPlanetInfoWindow planetInfoWindow;
  private UIPlanetListWindow planetListWindow;
  private UIKeybindWindow kbWindow;
  public UI()
  {
    planetInfoWindow = new SelectedPlanetInfoWindow(new PVector(width - 200, 300), new PVector(200, 0), true);
    planetListWindow = new UIPlanetListWindow(width - 200, 0, 200, 300, false);
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

    noStroke();
    float textSz = getUITextScale();
    
    textSize(round(24 * textSz));
    textAlign(LEFT, TOP);
    
    fill(0, 360, 360);
    text(OnMouseClickModeEnumManager.getCurrentModeAsDisplayString(), mouseX + 15, mouseY + 15);
    
    fill(0, 0, 360);
    text("Framerate: " + round(frameRate), 5, 5);
    text("Sim steps: " + PathSimulator.previousSimulationSteps, 5, 5 + 24 * textSz);
  }
  
  private float getUITextScale()
  {
    float windowWidth = width;
    float originalWidth = 1920;
    return windowWidth / originalWidth;
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
