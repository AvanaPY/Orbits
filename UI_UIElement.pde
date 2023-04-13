public abstract class UIElement
{
  protected float x, y, w, h;
  public UIElement(float _x, float _y, float _w, float _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  public abstract void render();
  public abstract boolean click(float mx, float my);
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
