public class PlanetInfoWindow
{
  private float x, y;
  private float w, h;
  private color bg, borderColor, textColor;
  private boolean active = true;
  private ArrayList<UIElement> elements = new ArrayList<UIElement>();
  public PlanetInfoWindow(PVector position, PVector dimensions, color bg, color borderColor, color textColor)
  {
    x = position.x;
    y = position.y;
    w = dimensions.x;
    h = dimensions.y;
    this.bg = bg;
    this.borderColor = borderColor;
    this.textColor = textColor;
    
    float _y = 0;
    elements.add(new UIEditableTextElement(0, _y, w, 20, (Body body) -> {
      return body.toString();
    }
    , "", true));
    
    _y += 20;
    elements.add(new UIEditableBooleanElement(0, _y, w, 20, (Body body) -> {
      return body.fixed;
    },
    () -> { 
      Body body = PlanetSelector.getCurrentlySelectedPlanet(); 
      body.setFixed(!body.fixed);
    }, "Toggle",
    "Fixed: "));
  
    _y += 20;
    elements.add(new UIEditableFloatElement(0, _y, w, 20, (Body body) -> {
      return body.radius;
    },
    () -> { 
      Body body = PlanetSelector.getCurrentlySelectedPlanet(); 
      body.setRadius(body.radius + 1);
    }, "^",
    () -> { 
      Body body = PlanetSelector.getCurrentlySelectedPlanet(); 
      body.setRadius(body.radius - 1);
    }, "v",
    "R "));

    _y += 20;
    elements.add(new UIEditableFloatElement(0, _y, w, 20, (Body body) -> {
      return body.gravity;
    },
    () -> { 
      Body body = PlanetSelector.getCurrentlySelectedPlanet(); 
      body.setGravity(body.gravity + 1);
    }, "^",
    () -> { 
      Body body = PlanetSelector.getCurrentlySelectedPlanet(); 
      body.setGravity(body.gravity - 1);
    }, "v",
    "G "));
    
    
    _y += 20;
    elements.add(new UIEditableFloatElement(0, _y, w, 20, (Body body) -> {
      return body.mass;
    }
    , "M "));

  }

  public boolean positionInsideWindow(float px, float py)
  {
    return px >= x && px <= x + w && py >= y && py <= y + h;
  }
  
  public boolean active()
  {
    return active;
  }
  
  public void DrawPlanetInfoWindow()
  {
    if (!active)
      return;
    pushMatrix();
    translate(x, y);
    
    // Draw background
    fill(bg);
    noStroke();
    rect(0, 0, w, h);

    // Draw elements
    fill(textColor);
    textSize(12);
    for (UIElement uie : elements)
      uie.render();
      
    // Draw border
    stroke(borderColor);
    noFill();
    rect(0, 0, w, h);
      
    popMatrix();
  }

  public void toggle()
  {
    active = !active;
  }

  public boolean click(float mx, float my)
  {
    if(!active)
      return false;
    if (mx < x || mx > x + w || my < y || my > y + h)
      return false;

    for (UIElement e : elements)
      e.click(mx - x, my - y);
    return true;
  }
}
