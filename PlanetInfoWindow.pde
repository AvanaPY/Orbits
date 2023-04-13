public class PlanetInfoWindow
{
  private float x, y;
  private float w, h;
  private boolean active = true;
  private ArrayList<UIElement> elements = new ArrayList<UIElement>();
  public PlanetInfoWindow(PVector position, PVector dimensions)
  {
    x = position.x;
    y = position.y;
    w = dimensions.x;
    h = dimensions.y;
    
    /**********************************************MISC**********************************************/
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
    elements.add(
      new UIDisplayableColorElement(0, _y, w, 20, "Color",
        (Body body) -> { return body.c; }));
  
  
    /*********************************************VECTOR*********************************************/
    _y += 40;
    elements.add(
      new UIDisplayablePVectorElement(0, _y, w, 20, "Position", 
        (Body body) -> { return body.position; }));
        
    _y += 20;
    elements.add(
      new UIDisplayablePVectorElement(0, _y, w, 20, "Velocity", 
        (Body body) -> { return body.velocity; }));
        
    _y += 20;
    elements.add(
      new UIDisplayablePVectorElement(0, _y, w, 20, "Acceleration", 
        (Body body) -> { return body.acceleration; }));
  
  
    /**********************************************BODY**********************************************/
    _y += 40;
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
    fill(backgroundColor);
    noStroke();
    rect(0, 0, w, h);

    // Draw elements
    for (UIElement uie : elements)
    {
      fill(color(190, 200, 50));
      textSize(12);
      uie.render();
    }
      
    // Draw border
    stroke(borderColor);
    noFill();
    rect(0, 0, w - 1, h - 1);
      
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
