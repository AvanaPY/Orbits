public class UIKeybindWindow extends UIElement
{
  private KeybindManager kbManager;
  private ArrayList<UIElement> elements;
  public UIKeybindWindow(float x, float y, float w, float h)
  {
    super(x, y, w, h);
    kbManager = KeybindManager.instance;
    elements = new ArrayList<UIElement>();
    
    float _y = y;
    float entryHeight = 20;
    for(Keybind kb : kbManager.keybinds)
    {
      elements.add(new UIKeybind(x, _y, w, entryHeight, kb));
      _y += entryHeight;
    }
  }
  
  public void renderUI()
  {
    noStroke();
    fill(backgroundColor);
    rect(x, y, w, h);
    
    for(UIElement e : elements)
      e.renderUI();
    
    strokeWeight(1);
    stroke(0, 0, 360);
    noFill();
    rect(x, y, w, h-1);
  }
  
  public boolean onClick(float x, float y) { 
    return positionInElement(x, y); 
  }

  public class UIKeybind extends UIElement 
  {
    private String text;
    private String keybind;
    public UIKeybind(float x, float y, float w, float h, Keybind kb)
    {
      super(x, y, w, h);
      this.text = kb.displayName;
      this.keybind = kb.displayKeybind;
    }
    public void renderUI()
    {
      noFill();
      stroke(0, 0, 0);
      strokeWeight(1);
      pushMatrix();
      translate(x, y);
      rect(0, 0, w, h);
      
      line(w * 6 / 8, 0, w * 6 / 8, h);
      
      fill(textColor);
      textAlign(LEFT, CENTER);
      text(text, 5, h / 2);
      textAlign(CENTER, CENTER);
      text(keybind, w * 7 / 8, h / 2);
      popMatrix();
    }
    
    public boolean onClick(float x, float y) { 
      return positionInElement(x, y); 
    }
  }
}
