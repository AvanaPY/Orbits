public abstract class UIElement
{
  protected float x, y, maxWidth, maxHeight;
  public abstract String getRenderText(Body selectedBody);
  public abstract void render();
  public abstract void click(float mx, float my);
}

public interface IBodyTextDataGetter {
  String getData(Body body);
}
public interface IBodyFloatDataGetter {
  Float getData(Body body);
}
public interface IBodyBooleanDataGetter {
  Boolean getData(Body body); 
}
public interface IBodyInteractiveAction {
  void action();
}
