public enum CursorMode
{
  ARROW,
    CROSS,
    HAND,
    MOVE,
    TEXT,
    WAIT,
    CIRCLE,
    DOT
}
public class CursorModeManager
{
  private CursorMode cursorMode;
  private color cursorColor;

  public CursorModeManager()
  {
    cursorMode  = CursorMode.CIRCLE;
    cursorColor = color(0, 0, 360, 360);
  }

  public CursorMode getCursorMode()
  {
    return cursorMode;
  }
  public CursorMode setCursorMode(CursorMode mode)
  {
    cursorMode = mode;
    return mode;
  }
  public color getCursorColor()
  {
    return cursorColor;
  }
  public void setCursorColor(color c)
  {
    cursorColor = c;
  }
}
