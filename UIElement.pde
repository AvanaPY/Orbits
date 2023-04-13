public abstract class UIElement
{
  protected float x, y, maxWidth, maxHeight;
  public UIElement(float _x, float _y, float _w, float _h)
  {
    x = _x;
    y = _y;
    maxWidth = _w;
    maxHeight = _h;
  }
  public abstract String getRenderText(Body selectedBody);
  public abstract void render();
  public abstract void click(float mx, float my);
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
