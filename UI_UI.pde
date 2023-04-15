public class UI
{
  private UIElement[] elements;

  private SelectedPlanetInfoWindow planetInfoWindow;
  private UIPlanetListWindow planetListWindow;
  private UIKeybindWindow kbWindow;
  public UI()
  {
    planetInfoWindow = new SelectedPlanetInfoWindow(new PVector(width - 250, 0), new PVector(250, 0), true);
    planetListWindow = new UIPlanetListWindow(0, 0, 150, 300, false);
    kbWindow = new UIKeybindWindow(0, 300, 150, 200);

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
    textAlign(LEFT, BOTTOM);
    text("Mode: " + OnMouseClickModeEnumManager.getCurrentOnMouseClickModeEnum(), 5, height - 5);
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
    println("-----");
    for (UIElement element : elements)
    {
      println("Checking", element);
      if (element.click(mouseX, mouseY))
      {
        println("Clicked", element);
        return true;
      }
    }
    return false;
  }

  public boolean mouseDragged(float x, float y)
  {
    if (positionInUI(x, y))
      return true;
    return false;
  }
}
