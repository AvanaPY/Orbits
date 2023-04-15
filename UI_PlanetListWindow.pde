public class UIPlanetListWindow extends UIElement
{
  private ArrayList<UIPlanetListEntryElement> elements;
  private boolean grow;

  private float entryHeight = 20;
  private float startingHeight;

  public UIPlanetListWindow(float x, float y, float w, float h, boolean grow)
  {
    super(x, y, w, h);
    this.grow = grow;
    this.elements = new ArrayList<UIPlanetListEntryElement>();
    startingHeight = h;
  }

  public void addNewPlanet(Body body)
  {
    UIPlanetListEntryElement entry = new UIPlanetListEntryElement(x, y, w, 20, body);
    elements.add(entry);

    updateElementPositions();
    updateHeightIfGrow();
  }

  public void removeBodyFromList(Body body)
  {
    for (int i = 0; i < elements.size(); i++)
    {
      UIPlanetListEntryElement element = elements.get(i);
      if (body == element.body)
      {
        elements.remove(i);
        break;
      }
    }
    updateElementPositions();
    updateHeightIfGrow();
  }

  private void updateElementPositions()
  {
    for (int i = 0; i < elements.size(); i++) {
      elements.get(i).y = y + i * entryHeight;
    }
  }
  private void updateHeightIfGrow()
  {
    if (!grow)
      return;
    float currentEvaluatedHeight = entryHeight * elements.size();
    float minHeight = startingHeight;
    h = max(minHeight, currentEvaluatedHeight);
  }

  public void renderUI()
  {
    noStroke();
    fill(backgroundColor);
    rect(x, y, w, h);

    for (UIElement uie : elements)
    {
      if(!grow && uie.y + uie.h > y + h)
        continue;
      uie.render();
    }
    strokeWeight(1);
    noFill();
    stroke(0, 0, 360);
    rect(x, y, w, h);
  }

  public boolean onClick(float mx, float my)
  {
    if (!positionInElement(mx, my))
      return false;
    for (UIElement uie : elements)
      uie.click(mx, my);
    return true;
  }
}

class UIPlanetListEntryElement extends UIElement
{
  private Body body;
  public UIPlanetListEntryElement(float x, float y, float w, float h, Body body)
  {
    super(x, y, w, h);
    this.body = body;
  }

  public String getRenderText(Body body)
  {
    return body.name;
  }

  public void renderUI()
  {
    Body globalSelectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();

    String planetName = body.name;
    color col = body.c;
    float cellCenter01 = x + w / 2;

    if (globalSelectedPlanet != null && globalSelectedPlanet == body)
    {
      float h = hue(backgroundColor);
      float s = saturation(backgroundColor);
      float b = brightness(backgroundColor);
      fill(h, s, b);
    } else
      noFill();
    strokeWeight(1);
    stroke(0, 0, 0);
    rect(x, y, w, h);

    fill(col);
    noStroke();
    textAlign(CENTER, CENTER);
    text(planetName, cellCenter01, y + h / 2);
  }

  public boolean onClick(float mx, float my) {
    if (!positionInElement(mx, my))
      return false;
    PlanetSelector.setSelectedPlanet(body);
    return true;
  }
}
