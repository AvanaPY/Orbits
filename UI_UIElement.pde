public abstract class UIElement
{
  protected float x, y, w, h;
  protected boolean active;
  public UIElement(float _x, float _y, float _w, float _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    active = true;
  }
  public void render()
  {
    if(active)
      renderUI();
  }
  
  public boolean positionInElement(float _x, float _y)
  {
    return x <= _x && _x <= x + w && y <= _y && _y < y + h;
  }
  
  public void toggle()
  {
    active = !active;
  }
  
  public boolean click(float mx, float my)
  {
    if(!active)
      return false;
    if(!positionInElement(mx, my))
      return false;
    return onClick(mx, my);
  }
  
  public abstract void renderUI();
  public abstract boolean onClick(float mx, float my);
}

public interface BodyTextDataGetter {
  String getData(Body body);
}
public interface BodyFloatDataGetter {
  Float getData(Body body);
}
public interface BodyBooleanDataGetter {
  Boolean getData(Body body); 
}
public interface BodyPVectorDataGetter {
  PVector getData(Body body);
}
public interface BodyColorDataGetter {
  color getData(Body body);
}
public interface InteractiveAction {
  void action();
}
