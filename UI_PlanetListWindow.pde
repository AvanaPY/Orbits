public class UIPlanetListWindow extends UIElement
{
  private ArrayList<UIPlanetListEntryElement> elements;
  private boolean grow;
  
  private float entryHeight = 20;

  public UIPlanetListWindow(float x, float y, float w, float h, boolean grow)
  {
    super(x, y, w, h);
    this.grow = grow;
    this.elements = new ArrayList<UIPlanetListEntryElement>();
  }

  public void addNewPlanet(Body body)
  {
    float y = entryHeight * elements.size();
    UIPlanetListEntryElement entry = new UIPlanetListEntryElement(x, y, w, 20, body);
    elements.add(entry);
  }

  public void removeBodyFromList(Body body)
  {
    for(int i = 0; i < elements.size(); i++)
    {
      UIPlanetListEntryElement element = elements.get(i);
      if(body == element.body)
      {
        elements.remove(i);
        break;
      }
    }
    updateElementPositions();
  }
  
  private void updateElementPositions()
  {
    for(int i = 0; i < elements.size(); i++)
    {
      elements.get(i).y = i * entryHeight;
    }
  }

  public void render()
  {
    noStroke();
    fill(backgroundColor);
    rect(x, y, w, h);

    for (UIElement uie : elements)
      uie.render();

    stroke(0, 0, 360);
    strokeWeight(2);
    noFill();
    rect(x, y, w, h);
  }

  public boolean click(float mx, float my)
  {
    if(mx < x || mx > x + w || my < y || my > y + h)
      return false;
    for(UIElement uie : elements)
      if(uie.click(mx, my))
        return true;
    return false;
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

  public void render()
  {
    strokeWeight(1);
    noFill();
    stroke(0, 0, 0);
    rect(x, y, w, h);

    String planetName = body.name;
    color col = body.c;
    float cellCenter01 = x + w / 2;
    fill(col);
    noStroke();
    textAlign(CENTER, CENTER);
    text(planetName, cellCenter01, y + h / 2);
  }

  public boolean click(float mx, float my) {
    return false;
  }
}
